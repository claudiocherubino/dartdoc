{{>head}}

{{#self}}
  {{>source_link}}
  # {{{nameWithGenerics}}} {{kind}} {{>categorization}}
{{/self}}

{{#function}}
  {{>callable_multiline}}
{{>documentation}}

{{>source_code}}

{{/function}}

{{>footer}}
