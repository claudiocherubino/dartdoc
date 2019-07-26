// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library dartdoc.templates;

import 'dart:async' show Future;
import 'dart:io' show File;

import 'package:dartdoc/src/resource_loader.dart' as loader;
import 'package:mustache/mustache.dart';

const _partials = const <String>[
  'callable',
  'callable_multiline',
  'categorization',
  'class',
  'constant',
  'footer',
  'head',
  'library',
  'mixin',
  'packages',
  'property',
  'features',
  'documentation',
  'name_summary',
  'source_code',
  'source_link',
  'accessor_getter',
  'accessor_setter',
];

Future<Map<String, String>> _loadPartials(List<String> headerPaths,
    List<String> footerPaths, List<String> footerTextPaths) async {
  final String headerPlaceholder = '<!-- header placeholder -->';
  final String footerPlaceholder = '<!-- footer placeholder -->';
  final String footerTextPlaceholder = '<!-- footer-text placeholder -->';

  headerPaths ??= [];
  footerPaths ??= [];
  footerTextPaths ??= [];

  var partials = <String, String>{};

  Future<String> _loadPartial(String templatePath) async {
    String template = await _getTemplateFile(templatePath);

    if (templatePath.contains('_head')) {
      String headerValue = headerPaths
          .map((path) => new File(path).readAsStringSync())
          .join('\n');
      template = template.replaceAll(headerPlaceholder, headerValue);
    }

    if (templatePath.contains('_footer')) {
      String footerValue = footerPaths
          .map((path) => new File(path).readAsStringSync())
          .join('\n');
      template = template.replaceAll(footerPlaceholder, footerValue);

      String footerTextValue = footerTextPaths
          .map((path) => new File(path).readAsStringSync())
          .join('\n');
      template = template.replaceAll(footerTextPlaceholder, footerTextValue);
    }

    return template;
  }

  for (String partial in _partials) {
    partials[partial] = await _loadPartial('_$partial.md');
  }

  return partials;
}

Future<String> _getTemplateFile(String templateFileName) =>
    loader.loadAsString('package:dartdoc/templates/markdown/$templateFileName');

class Templates {
  final Template categoryTemplate;
  final Template classTemplate;
  final Template enumTemplate;
  final Template constantTemplate;
  final Template constructorTemplate;
  final Template functionTemplate;
  final Template indexTemplate;
  final Template libraryTemplate;
  final Template methodTemplate;
  final Template mixinTemplate;
  final Template propertyTemplate;
  final Template topLevelConstantTemplate;
  final Template topLevelPropertyTemplate;
  final Template typeDefTemplate;

  static Future<Templates> create(
      {List<String> headerPaths,
      List<String> footerPaths,
      List<String> footerTextPaths}) async {
    var partials =
        await _loadPartials(headerPaths, footerPaths, footerTextPaths);

    Template _partial(String name) {
      String partial = partials[name];
      if (partial == null || partial.isEmpty) {
        throw new StateError('Did not find partial "$name"');
      }
      return Template(partial);
    }

    Future<Template> _loadTemplate(String templatePath) async {
      String templateContents = await _getTemplateFile(templatePath);
      return Template(templateContents, partialResolver: _partial);
    }

    var indexTemplate = await _loadTemplate('index.md');
    var libraryTemplate = await _loadTemplate('library.md');
    var categoryTemplate = await _loadTemplate('category.md');
    var classTemplate = await _loadTemplate('class.md');
    var enumTemplate = await _loadTemplate('enum.md');
    var functionTemplate = await _loadTemplate('function.md');
    var methodTemplate = await _loadTemplate('method.md');
    var constructorTemplate = await _loadTemplate('constructor.md');
    var propertyTemplate = await _loadTemplate('property.md');
    var constantTemplate = await _loadTemplate('constant.md');
    var topLevelConstantTemplate =
        await _loadTemplate('top_level_constant.md');
    var topLevelPropertyTemplate =
        await _loadTemplate('top_level_property.md');
    var typeDefTemplate = await _loadTemplate('typedef.md');
    var mixinTemplate = await _loadTemplate('mixin.md');

    return new Templates._(
        indexTemplate,
        categoryTemplate,
        libraryTemplate,
        classTemplate,
        enumTemplate,
        functionTemplate,
        methodTemplate,
        constructorTemplate,
        propertyTemplate,
        constantTemplate,
        topLevelConstantTemplate,
        topLevelPropertyTemplate,
        typeDefTemplate,
        mixinTemplate);
  }

  Templates._(
      this.indexTemplate,
      this.categoryTemplate,
      this.libraryTemplate,
      this.classTemplate,
      this.enumTemplate,
      this.functionTemplate,
      this.methodTemplate,
      this.constructorTemplate,
      this.propertyTemplate,
      this.constantTemplate,
      this.topLevelConstantTemplate,
      this.topLevelPropertyTemplate,
      this.typeDefTemplate,
      this.mixinTemplate);
}
