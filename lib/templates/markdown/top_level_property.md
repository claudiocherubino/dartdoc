{{>head}}

{{#self}}
  {{>source_link}}
  # {{{name}}} {{kind}} {{>categorization}}

  {{#hasNoGetterSetter}}
      {{{ linkedReturnType }}}
      {{>name_summary}}
      {{>features}}
    {{>documentation}}
    {{>source_code}}
  {{/hasNoGetterSetter}}

  {{#hasExplicitGetter}}
    {{>accessor_getter}}
  {{/hasExplicitGetter}}

  {{#hasExplicitSetter}}
    {{>accessor_setter}}
  {{/hasExplicitSetter}}
{{/self}}

{{>footer}}