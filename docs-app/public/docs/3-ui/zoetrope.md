# Zoetrope

A slider element built with browser native scrolling, with optional controls.

<div class="featured-demo auto-height">

```gjs live preview no-shadow
import { Zoetrope } from "ember-primitives";
import { on } from "@ember/modifier";

<template>
  <div class="demo">
    <Zoetrope @offset={{40}} @gap={{8}}>
      <:header>
        <h2>Heading</h2>
      </:header>
      <:controls as |z|>
        <div>
          <button
            type="button"
            {{on "click" z.scrollLeft}}
            disabled={{z.cannotScrollLeft}}
          >&lt;</button>

          <button
            type="button"
            {{on "click" z.scrollRight}}
            disabled={{z.cannotScrollRight}}
          >&gt;</button>
        </div>
      </:controls>
      <:content>
        <a href="#" class="card">1</a>
        <a href="#" class="card">2</a>
        <a href="#" class="card">3</a>
        <a href="#" class="card">4</a>
        <a href="#" class="card">5</a>
        <a href="#" class="card">6</a>
        <a href="#" class="card">7</a>
        <a href="#" class="card">8</a>
        <a href="#" class="card">9</a>
        <a href="#" class="card">10</a>
        <a href="#" class="card">11</a>
        <a href="#" class="card">12</a>
        <a href="#" class="card">13</a>
        <a href="#" class="card">14</a>
        <a href="#" class="card">15</a>
        <a href="#" class="card">16</a>
        <a href="#" class="card">17</a>
        <a href="#" class="card">18</a>
        <a href="#" class="card">19</a>
        <a href="#" class="card">20</a>
        <a href="#" class="card">21</a>
        <a href="#" class="card">22</a>
        <a href="#" class="card">23</a>
        <a href="#" class="card">24</a>
        <a href="#" class="card">25</a>
        <a href="#" class="card">26</a>
        <a href="#" class="card">27</a>
        <a href="#" class="card">28</a>
        <a href="#" class="card">29</a>
        <a href="#" class="card">30</a>
        <a href="#" class="card">31</a>
        <a href="#" class="card">32</a>
        <a href="#" class="card">33</a>
        <a href="#" class="card">34</a>
        <a href="#" class="card">35</a>
        <a href="#" class="card">36</a>
        <a href="#" class="card">37</a>
        <a href="#" class="card">38</a>
        <a href="#" class="card">39</a>
        <a href="#" class="card">40</a>
        <a href="#" class="card">41</a>
        <a href="#" class="card">42</a>
        <a href="#" class="card">43</a>
        <a href="#" class="card">44</a>
        <a href="#" class="card">45</a>
        <a href="#" class="card">46</a>
        <a href="#" class="card">47</a>
        <a href="#" class="card">48</a>
        <a href="#" class="card">49</a>
        <a href="#" class="card">50</a>
        <a href="#" class="card">51</a>
        <a href="#" class="card">52</a>
        <a href="#" class="card">53</a>
        <a href="#" class="card">54</a>
        <a href="#" class="card">55</a>
        <a href="#" class="card">56</a>
        <a href="#" class="card">57</a>
        <a href="#" class="card">58</a>
        <a href="#" class="card">59</a>
        <a href="#" class="card">60</a>
      </:content>
    </Zoetrope>
  </div>

  <style>
    .demo { display: flex; gap: 1rem; } .demo h2 { margin: 0; } .card { background: red; color:
    #fff; height: 150px; padding: 24px; text-shadow: 1px 1px 1px rgba(0, 0, 0, 0.5); width: 200px; }
    .card:nth-child(1n) { background: blue; } .card:nth-child(2n) { background: green; }
    .card:nth-child(3n) { background: yellow; } .card:nth-child(4n) { background: purple; }
    .card:nth-child(5n) { background: orange; } .card:nth-child(6n) { background: pink; }
    .card:nth-child(7n) { background: brown; } .card:nth-child(8n) { background: black; }
    .card:nth-child(9n) { background: mediumaquamarine; } .card:nth-child(10n) { background: gray; }

  </style>
</template>
```

</div>

## Features

- Automatic and manual control over when the image renders.
- Fallback accepts any content.
- Optionally delay fallback rendering to avoid content flashing.

## Anatomy

```js
import { Avatar } from "ember-primitives";
```

or for non-tree-shaking environments:

```js
import { Avatar } from "ember-primitives/components/avatar";
```

```gjs
import { Avatar } from "ember-primitives";

<template>
  <Avatar @src="..." as |a|>
    <a.Image />
    <a.Fallback>
      any content here
    </a.Fallback>
  </Avatar>
</template>
```

## Accessibility

An `alt` attribute is required, and in development, the UI will show an indication of a missing `alt` value if one is not provided.

## API Reference

```gjs live no-shadow
import { ComponentSignature } from "kolay";

<template>
  <ComponentSignature
    @package="ember-primitives"
    @module="declarations/components/avatar"
    @name="Avatar"
  />
</template>
```

### State Attributes

There are state attributes available on the the root element of this component.
These may allow for stateful CSS-only stylings of the Avatar component.

|      key       | description                                |
| :------------: | :----------------------------------------- |
| `data-loading` | the loading state of the image             |
|  `data-error`  | will be "true" if the image failed to load |
