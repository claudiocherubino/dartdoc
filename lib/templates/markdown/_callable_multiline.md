{{#hasAnnotations}}
<ol>
  {{#annotations}}
  <li>{{{.}}}</li>
  {{/annotations}}
</ol>
{{/hasAnnotations}}
{{{ linkedReturnType }}}
{{>name_summary}}{{{genericParameters}}}({{#hasParameters}}{{{linkedParamsLines}}}{{/hasParameters}})
