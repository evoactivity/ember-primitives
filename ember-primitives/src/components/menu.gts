import { hash, uniqueId } from '@ember/helper';
import { on } from '@ember/modifier';

import { modifier } from 'ember-modifier';
import { cell } from 'ember-resources';
import { getTabster, getTabsterAttribute, Types } from 'tabster';

import { Popover, type Signature as PopoverSignature } from './popover.gts';

import type { TOC } from '@ember/component/template-only';
import type { WithBoundArgs } from '@glint/template';

const TABSTER_CONFIG_CONTENT = getTabsterAttribute(
  {
    mover: {
      direction: Types.MoverDirections.Both,
      cyclic: true,
    },
    deloser: {},
    // groupper: {},
    // modalizer: {},
  },
  true
);

const TABSTER_CONFIG_TRIGGER = getTabsterAttribute(
  {
    deloser: {},
  },
  true
);

export interface Signature {
  Args: PopoverSignature['Args'];
  Blocks: {
    default: [
      {
        arrow: PopoverSignature['Blocks']['default'][0]['arrow'];
        Trigger: WithBoundArgs<typeof Trigger, 'triggerId' | 'contentId' | 'isOpen' | 'hook'>;
        Content: WithBoundArgs<
          typeof Content,
          'triggerId' | 'contentId' | 'isOpen' | 'PopoverContent'
        >;
        isOpen: boolean;
      },
    ];
  };
}

const Separator: TOC<{
  Element: HTMLDivElement;
  Args: {};
  Blocks: { default: [] };
}> = <template>
  <div role="separator" ...attributes>
    {{yield}}
  </div>
</template>;

const Item: TOC<{
  Element: HTMLButtonElement;
  Args: { onSelect: (event: Event) => void };
  Blocks: { default: [] };
}> = <template>
  <button
    type="button"
    role="menuitem"
    {{! @glint-ignore !}}
    {{(if @onSelect (modifier on "click" @onSelect))}}
    ...attributes
  >
    {{yield}}
  </button>
</template>;

const installContent = modifier<{
  Element: HTMLElement;
  Args: { Named: { isOpen: ReturnType<typeof cell<boolean>>; triggerId: string } };
}>((element, _: [], { isOpen, triggerId }) => {
  // focus first focusable element on the content
  const tabster = getTabster(window);
  const firstFocusable = tabster?.focusable.findFirst({
    container: element,
  });

  firstFocusable?.focus();

  // listen for "outside" clicks
  function onDocumentClick(e: MouseEvent) {
    const trigger = document.getElementById(triggerId);

    if (
      isOpen.current &&
      e.target &&
      !element.contains(e.target as HTMLElement) &&
      !trigger?.contains(e.target as HTMLElement)
    ) {
      isOpen.current = false;
    }
  }

  // listen for the escape key
  function onDocumentKeydown(e: KeyboardEvent) {
    if (isOpen.current && e.key === 'Escape') {
      isOpen.current = false;
    }
  }

  document.addEventListener('click', onDocumentClick);
  document.addEventListener('keydown', onDocumentKeydown);

  return () => {
    document.removeEventListener('click', onDocumentClick);
    document.removeEventListener('keydown', onDocumentKeydown);
  };
});

const Content: TOC<{
  Element: HTMLDivElement;
  Args: {
    triggerId: string;
    contentId: string;
    isOpen: ReturnType<typeof cell<boolean>>;
    PopoverContent: PopoverSignature['Blocks']['default'][0]['Content'];
  };
  Blocks: { default: [{ Item: typeof Item; Separator: typeof Separator }] };
}> = <template>
  {{#if @isOpen.current}}
    <@PopoverContent
      id={{@contentId}}
      role="menu"
      data-tabster={{TABSTER_CONFIG_CONTENT}}
      tabindex="0"
      {{installContent isOpen=@isOpen triggerId=@triggerId}}
      {{on "click" @isOpen.toggle}}
      ...attributes
    >
      {{yield (hash Item=Item Separator=Separator)}}
    </@PopoverContent>
  {{/if}}
</template>;

const Trigger: TOC<{
  Element: HTMLButtonElement;
  Args: {
    triggerId: string;
    contentId: string;
    isOpen: ReturnType<typeof cell<boolean>>;
    hook: PopoverSignature['Blocks']['default'][0]['hook'];
  };
  Blocks: { default: [] };
}> = <template>
  <button
    data-tabster={{TABSTER_CONFIG_TRIGGER}}
    type="button"
    id={{@triggerId}}
    aria-controls={{if @isOpen.current @contentId}}
    aria-haspopup="menu"
    aria-expanded={{if @isOpen.current "true" "false"}}
    {{@hook}}
    {{on "click" @isOpen.toggle}}
    ...attributes
  >
    {{yield}}
  </button>
</template>;

const IsOpen: () => ReturnType<typeof cell<boolean>> = () => cell<boolean>(false);

export const Menu: TOC<Signature> = <template>
  {{#let (IsOpen) (uniqueId) (uniqueId) as |isOpen contentId triggerId|}}
    <Popover
      @flipOptions={{@flipOptions}}
      @middleware={{@middleware}}
      @offsetOptions={{@offsetOptions}}
      @placement={{@placement}}
      @shiftOptions={{@shiftOptions}}
      @strategy={{@strategy}}
      @inline={{@inline}}
      as |p|
    >

      {{yield
        (hash
          Trigger=(component
            Trigger hook=p.hook isOpen=isOpen triggerId=triggerId contentId=contentId
          )
          Content=(component
            Content PopoverContent=p.Content isOpen=isOpen triggerId=triggerId contentId=contentId
          )
          arrow=p.arrow
          isOpen=isOpen.current
        )
      }}
    </Popover>
  {{/let}}
</template>;

export default Menu;
