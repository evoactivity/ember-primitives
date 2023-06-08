import { highlight } from 'docs-app/components/highlight';
import { Compiled, defaultOptions } from 'docs-app/markdown';

import { Load } from './utils'

import type { TOC } from '@ember/component/template-only';
import type { DeclarationReference,DeclarationReflection,ReferenceType, TupleType } from 'typedoc';

/**
  * Assumptions:
  * - we are documenting public API
  *   - component properties and methods are not public API
  *     - including the constructor, inherited methods, etc
  *   - only the signature describes what the public API is.
  */
export const APIDocs: TOC<{
  Args: {
    module: string;
    name: string;
  }
}> = <template>
  <Load @module="{{@module}}" @name="{{name}}" as |info|>
    <Declaration @info={{info}} />
  </Load>
</template>;

export const CommentQuery: TOC<{
  Args: {
    module: string;
    name: string;
  },
}> = <template>
  <Load @module={{@module}} @name={{@name}} as |info|>
    <Comment @info={{info}} />
  </Load>
</template>;


const join = (lines: string[]) => lines.join('\n');
const text = (lines: { text: string }[]) => lines.map(line => line.text);

export function isGlimmerComponent(info: DeclarationReference) {
  let extended = ( info as any)?.extendedTypes?.[0]

  if (!extended) return false;

  return extended.name === 'default' && extended.package === '@glimmer/component';
}

export const Comment: TOC<{
  Args: {
    info: {
      comment?: {
        summary?: { text: string }[]
      }
    }
  }
}> = <template>
  {{#if @info.comment.summary}}
    {{#let (Compiled (join (text @info.comment.summary)) defaultOptions) as |compiled|}}
      {{#if compiled.isReady}}
        <div class="typedoc-rendered-comment" {{highlight}}>
          <compiled.component />
        </div>
      {{/if}}
    {{/let}}
  {{/if}}
</template>;


const isIgnored = (name: string) => ['__type', 'TOC', 'TemplateOnlyComponent'].includes(name);
const isConst = (x: { flags: { isConst: boolean }}) => x.flags.isConst;
const not = (x: unknown) => !x;

const Declaration: TOC<{
  Args: {
    info: DeclarationReflection | undefined
  }
}> = <template>
  {{#if @info}}
    {{#if (not (isIgnored @info.name))}}
      <span class="typedoc-declaration-name">{{@info.name}}</span>
    {{/if}}

    {{#if (isConst @info)}}
      <Comment @info={{@info}} />
    {{/if}}

    {{#if @info.type}}
      {{! @glint-expect-error }}
      <Type @info={{@info.type}} />
    {{/if}}

    {{#if @info.children}}
      <ul class='typedoc-declaration-children'>
      {{#each @info.children as |child|}}
        <li><Declaration @info={{child}} /></li>
      {{/each}}
      </ul>
    {{/if}}

    {{#if (not (isConst @info))}}
      {{#if @info.comment.summary}}
        <Comment @info={{@info}} />
      {{/if}}
    {{/if}}

  {{/if}}
</template>;

const Reflection: TOC<{ info: { declaration: DeclarationReflection }}> = <template>
  <Declaration @info={{@info.declaration}} />
</template>;

const isReference = (x: { type: string }) => x.type === 'reference';
const isReflection = (x: { type: string }) => x.type === 'reflection';
const isIntrinsic = (x: { type: string }) => x.type === 'intrinsic';
const isTuple = (x: { type: string }) => x.type === 'tuple';

// function typeArg(info: DeclarationReference) {
//   let extended = info?.extendedTypes?.[0]

//   if (!extended) return false;

//   return extended.typeArguments[0]
// }

const Reference: TOC<{ info: ReferenceType }> = <template>
  {{#if (not (isIgnored @info.name))}}
    <pre class="typedoc-reference">{{@info.name}}</pre>
  {{/if}}
  {{#each @info.typeArguments as |typeArg|}}
    {{! @glint-expect-error }}
     <Type @info={{typeArg}} />
  {{/each}}
</template>;

const Intrinsic: TOC<{ info: { name: string }}> = <template>
  <span class="typedoc-intrinsic">{{@info.name}}</span>
</template>;

const Tuple: TOC<{ Args: { info: TupleType }}> = <template>
  {{#each @info.elements as |element|}}
    {{! @glint-expect-error }}
    <Type @info={{element}} />
  {{/each}}
</template>;

export const Type: TOC<{ Args: { info: DeclarationReflection }}> = <template>
    {{! @glint-expect-error }}
  {{#if (isReference @info)}}
    {{! @glint-expect-error }}
    <Reference @info={{@info}} />
    {{! @glint-expect-error }}
  {{else if (isReflection @info)}}
    {{! @glint-expect-error }}
    <Reflection @info={{@info}} />
    {{! @glint-expect-error }}
  {{else if (isIntrinsic @info)}}
    <Intrinsic @info={{@info}} />
    {{! @glint-expect-error }}
  {{else if (isTuple @info)}}
    {{! @glint-expect-error }}
    <Tuple @info={{@info}} />
  {{else}}
    {{! template-lint-disable no-log }}
    {{log "Unknown Type" @info}}
  {{/if}}
</template>;
