{{>head}}

{{#self}}
  {{>source_link}}
  
  # {{{nameWithGenerics}}} {{kind}} {{>categorization}}
{{/self}}

{{#clazz}}
{{>documentation}}

{{#hasModifiers}}
{{#hasPublicSuperChainReversed}}
Inheritance
<dd><ul>
  <li>{{{linkedObjectType}}}</li>
  {{#publicSuperChainReversed}}
  <li>{{{linkedName}}}</li>
  {{/publicSuperChainReversed}}
  <li>{{{name}}}</li>
</ul></dd>
{{/hasPublicSuperChainReversed}}

{{#hasPublicInterfaces}}
Implemented types
<dd>
  <ul>
    {{#publicInterfaces}}
    <li>{{{linkedName}}}</li>
    {{/publicInterfaces}}
  </ul>
</dd>
{{/hasPublicInterfaces}}

{{#hasPublicMixins}}
Mixed in types
<dd><ul>
  {{#publicMixins}}
  <li>{{{linkedName}}}</li>
  {{/publicMixins}}
</ul></dd>
{{/hasPublicMixins}}

{{#hasPublicImplementors}}
Implementers
<dd><ul>
  {{#publicImplementors}}
  <li>{{{linkedName}}}</li>
  {{/publicImplementors}}
</ul></dd>
{{/hasPublicImplementors}}

{{#hasAnnotations}}
Annotations
<dd><ul>
  {{#annotations}}
  <li>{{{.}}}</li>
  {{/annotations}}
</ul></dd>
{{/hasAnnotations}}
{{/hasModifiers}}

{{#hasPublicConstructors}}
## Constructors

<dl>
  {{#publicConstructors}}
  <dt>
    {{{linkedName}}} ({{{ linkedParams }}})
  </dt>
  <dd>
    {{{ oneLineDoc }}}
    {{#isConst}}
    const
    {{/isConst}}
    {{#isFactory}}
    factory
    {{/isFactory}}
  </dd>
  {{/publicConstructors}}
</dl>
{{/hasPublicConstructors}}

{{#hasPublicProperties}}
## Properties

<dl>
  {{#allPublicInstanceProperties}}
  {{>property}}
  {{/allPublicInstanceProperties}}
</dl>
{{/hasPublicProperties}}

{{#hasPublicMethods}}
## Methods

<dl>
  {{#allPublicInstanceMethods}}
  {{>callable}}
  {{/allPublicInstanceMethods}}
</dl>
{{/hasPublicMethods}}

{{#hasPublicOperators}}
## Operators

<dl>
  {{#allPublicOperators}}
  {{>callable}}
  {{/allPublicOperators}}
</dl>
{{/hasPublicOperators}}

{{#hasPublicStaticProperties}}
## Static Properties

<dl>
  {{#publicStaticProperties}}
  {{>property}}
  {{/publicStaticProperties}}
</dl>
{{/hasPublicStaticProperties}}

{{#hasPublicStaticMethods}}
## Static Methods

<dl>
  {{#publicStaticMethods}}
  {{>callable}}
  {{/publicStaticMethods}}
</dl>
{{/hasPublicStaticMethods}}

{{#hasPublicConstants}}
## Constants

<dl>
  {{#publicConstants}}
  {{>constant}}
  {{/publicConstants}}
</dl>
{{/hasPublicConstants}}
{{/clazz}}

{{>footer}}
