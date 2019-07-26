{{>head}}

{{#self}}
  {{>source_link}}
  # {{{nameWithGenerics}}} {{kind}} {{>categorization}}
{{/self}}

  {{#typeDef}}
    {{>callable_multiline}}
  {{/typeDef}}

{{#typeDef}}
{{>documentation}}
{{>source_code}}
{{/typeDef}}

{{>footer}}
