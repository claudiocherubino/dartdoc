{{>head}}

{{#self}}
# {{name}} {{kind}}
{{>documentation}}

{{#hasPublicLibraries}}
## Libraries

<dl>
  {{#publicLibraries}}
    {{>library}}
  {{/publicLibraries}}
</dl>
{{/hasPublicLibraries}}

{{#hasPublicClasses}}
## Classes

<dl>
  {{#publicClasses}}
    {{>class}}
  {{/publicClasses}}
</dl>
{{/hasPublicClasses}}

{{#hasPublicMixins}}
## Mixins

<dl>
  {{#publicMixins}}
  {{>mixin}}
  {{/publicMixins}}
</dl>
{{/hasPublicMixins}}

{{#hasPublicConstants}}
## Constants

<dl>
  {{#publicConstants}}
    {{>constant}}
  {{/publicConstants}}
</dl>
{{/hasPublicConstants}}

{{#hasPublicProperties}}
## Properties

<dl>
  {{#publicProperties}}
    {{>property}}
  {{/publicProperties}}
</dl>
{{/hasPublicProperties}}

{{#hasPublicFunctions}}
## Functions

<dl>
  {{#publicFunctions}}
    {{>callable}}
  {{/publicFunctions}}
</dl>
{{/hasPublicFunctions}}

{{#hasPublicEnums}}
## Enums

<dl>
  {{#publicEnums}}
    {{>class}}
  {{/publicEnums}}
</dl>
{{/hasPublicEnums}}

{{#hasPublicTypedefs}}
## Typedefs

<dl>
  {{#publicTypedefs}}
    {{>callable}}
  {{/publicTypedefs}}
</dl>
{{/hasPublicTypedefs}}

{{#hasPublicExceptions}}
## Exceptions / Errors

<dl>
  {{#publicExceptions}}
    {{>class}}
  {{/publicExceptions}}
</dl>
{{/hasPublicExceptions}}
{{/self}}

{{>footer}}
