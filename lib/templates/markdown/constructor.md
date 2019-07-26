{{>head}}

{{#self}}
  {{>source_link}}
  # {{{nameWithGenerics}}} {{kind}}
{{/self}}

{{#constructor}}
{{#hasAnnotations}}
<ol>
  {{#annotations}}
  <li>{{{.}}}</li>
  {{/annotations}}
</ol>
{{/hasAnnotations}}
{{#isConst}}const{{/isConst}}
{{{nameWithGenerics}}}({{#hasParameters}}{{{linkedParamsLines}}}{{/hasParameters}}) {{#isDeprecated}}(deprecated){{/isDeprecated}}

{{>documentation}}

{{>source_code}}

{{/constructor}}

{{>footer}}
