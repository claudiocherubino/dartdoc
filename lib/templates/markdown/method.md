{{>head}}

{{#self}}
{{>source_link}}
# {{{nameWithGenerics}}} {{kind}}
{{/self}}

{{#method}}
  {{>callable_multiline}}
  {{>features}}
{{>documentation}}

{{>source_code}}

{{/method}}

{{>footer}}
