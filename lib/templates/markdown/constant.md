{{>head}}

{{#self}}
  {{>source_link}}
  #{{{name}}} {{kind}}
{{/self}}

{{#property}}
  {{{ linkedReturnType }}}
  {{>name_summary}}
  =
  {{{ constantValue }}}
{{/property}}

{{#property}}
{{>documentation}}
{{>source_code}}
{{/property}}

{{>footer}}
