import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { waitForPromise } from '@ember/test-waiters';

import { modifier } from 'ember-modifier';

import { getDataState } from './item';

export class AccordionContent extends Component<{
  Element: HTMLDivElement;
  Blocks: {
    default: [];
  };
  Args: {
    /**
     * Whether the content is expanded.
     */
    isExpanded: boolean;
    /**
     * The value of the accordion item.
     */
    value: string;
    /**
     * Whether the accordion item is disabled.
     */
    disabled?: boolean;
  }
}> {
  <template>
    <div {{this.setHeightAndWidthCssProperties @isExpanded}} {{this.handleHiddenState @isExpanded}} role="region" id={{@value}} data-state={{getDataState @isExpanded}} hidden={{this.isHidden}} data-disabled={{@disabled}} ...attributes>
      {{yield}}
    </div>
  </template>

  @tracked isHidden = !this.args.isExpanded;

  setHeightAndWidthCssProperties = modifier((element: HTMLDivElement, [_]) => {
    const currentStyleProperties = {
      hidden: element.hidden,
      display: element.style.display,
      transitionDuration: element.style.transitionDuration,
      animationName: element.style.animationName,
    }

    element.hidden = false;
    element.style.display = 'block';
    element.style.transitionDuration = '0s';
    element.style.animationName = 'none';

    const { height, width } = element.getBoundingClientRect();

    element.style.setProperty('--accordion-content-height', `${height}px`);
    element.style.setProperty('--accordion-content-width', `${width}px`);

    element.hidden = currentStyleProperties.hidden;
    element.style.display = currentStyleProperties.display;
    element.style.transitionDuration = currentStyleProperties.transitionDuration;
    element.style.animationName = currentStyleProperties.animationName;
  });

  handleHiddenState = modifier((element: HTMLDivElement, [isExpanded]) => {
    if (isExpanded) {
      this.isHidden = false;

      return;
    }

    // Wait for all animations to finish before hiding the element
    waitForPromise(Promise.allSettled(element.getAnimations().map((a) => a.finished))).then(() => { this.isHidden = true })
  });
}

export default AccordionContent;
