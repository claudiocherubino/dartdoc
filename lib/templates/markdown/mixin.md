{{>head}}

{{#self}}
  {{>source_link}}
  # {{{nameWithGenerics}}} {{kind}} {{>categorization}}
{{/self}}

{{#mixin}}
{{>documentation}}

{{#hasModifiers}}
<dl>
  {{#hasPublicSuperclassConstraints}}
  <dt>Superclass Constraints</dt>
  <dd><ul>
    {{#publicSuperclassConstraints}}
    <li>{{{linkedName}}}</li>
    {{/publicSuperclassConstraints}}
  </ul></dd>
  {{/hasPublicSuperclassConstraints}}

  {{#hasPublicSuperChainReversed}}
  <dt>Inheritance</dt>
  <dd><ul>
    <li>{{{linkedObjectType}}}</li>
    {{#publicSuperChainReversed}}
    <li>{{{linkedName}}}</li>
    {{/publicSuperChainReversed}}
    <li>{{{name}}}</li>
  </ul></dd>
  {{/hasPublicSuperChainReversed}}

  {{#hasPublicInterfaces}}
  <dt>Implements</dt>
  <dd>
    <ul>
      {{#publicInterfaces}}
      <li>{{{linkedName}}}</li>
      {{/publicInterfaces}}
    </ul>
  </dd>
  {{/hasPublicInterfaces}}

  {{#hasPublicMixins}}
  <dt>Mixes-in</dt>
  <dd><ul>
    {{#publicMixins}}
    <li>{{{linkedName}}}</li>
    {{/publicMixins}}
  </ul></dd>
  {{/hasPublicMixins}}

  {{#hasPublicImplementors}}
  <dt>Implemented by</dt>
  <dd><ul>
    {{#publicImplementors}}
    <li>{{{linkedName}}}</li>
    {{/publicImplementors}}
  </ul></dd>
  {{/hasPublicImplementors}}

  {{#hasAnnotations}}
  <dt>Annotations</dt>
  <dd><ul>
    {{#annotations}}
    <li>{{{.}}}</li>
    {{/annotations}}
  </ul></dd>
  {{/hasAnnotations}}
</dl>
</section>
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
{{/mixin}}

{{>footer}}
