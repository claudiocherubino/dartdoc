{{>head}}

{{#self}}
{{>source_link}}

# {{{name}}} {{kind}} {{>categorization}}
{{/self}}

{{#library}}
{{>documentation}}
{{/library}}

{{#library.hasPublicClasses}}
## Classes

{{#library.publicClasses}}
{{>class}}
{{/library.publicClasses}}

{{/library.hasPublicClasses}}

{{#library.hasPublicMixins}}
## Mixins

{{#library.publicMixins}}
{{>mixin}}
{{/library.publicMixins}}

{{/library.hasPublicMixins}}

{{#library.hasPublicConstants}}
## Constants

{{#library.publicConstants}}
{{>constant}}
{{/library.publicConstants}}

{{/library.hasPublicConstants}}

{{#library.hasPublicProperties}}
## Properties

{{#library.publicProperties}}
{{>property}}
{{/library.publicProperties}}

{{/library.hasPublicProperties}}

{{#library.hasPublicFunctions}}
## Functions

{{#library.publicFunctions}}
{{>callable}}
{{/library.publicFunctions}}

{{/library.hasPublicFunctions}}

{{#library.hasPublicEnums}}
## Enums

{{#library.publicEnums}}
{{>class}}
{{/library.publicEnums}}

{{/library.hasPublicEnums}}

{{#library.hasPublicTypedefs}}
## Typedefs

{{#library.publicTypedefs}}
{{>callable}}
{{/library.publicTypedefs}}

{{/library.hasPublicTypedefs}}

{{#library.hasPublicExceptions}}
## Exceptions / Errors

{{#library.publicExceptions}}
{{>class}}
{{/library.publicExceptions}}

{{/library.hasPublicExceptions}}


{{>footer}}
