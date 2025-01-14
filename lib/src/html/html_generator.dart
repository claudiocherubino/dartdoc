// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library dartdoc.html_generator;

import 'dart:async' show Future, StreamController, Stream;
import 'dart:io' show Directory, File;
import 'dart:isolate';

import 'package:dartdoc/dartdoc.dart';
import 'package:dartdoc/src/generator.dart';
import 'package:dartdoc/src/html/html_generator_instance.dart';
import 'package:dartdoc/src/html/template_data.dart';
import 'package:dartdoc/src/html/templates.dart';
import 'package:dartdoc/src/model.dart';
import 'package:path/path.dart' as path;

typedef String Renderer(String input);

// Generation order for libraries:
//   constants
//   typedefs
//   properties
//   functions
//   enums
//   classes
//   exceptions
//
// Generation order for classes:
//   constants
//   static properties
//   static methods
//   properties
//   constructors
//   operators
//   methods

class HtmlGenerator extends Generator {
  final Templates _templates;
  final HtmlGeneratorOptions _options;
  HtmlGeneratorInstance _instance;

  final StreamController<void> _onFileCreated =
      new StreamController(sync: true);

  @override
  Stream<void> get onFileCreated => _onFileCreated.stream;

  @override
  final Set<String> writtenFiles = new Set<String>();

  static Future<HtmlGenerator> create(
      {HtmlGeneratorOptions options,
      List<String> headers,
      List<String> footers,
      List<String> footerTexts}) async {
    var templates = await Templates.create(
        headerPaths: headers,
        footerPaths: footers,
        footerTextPaths: footerTexts);

    return new HtmlGenerator._(
        options ?? new HtmlGeneratorOptions(), templates);
  }

  HtmlGenerator._(this._options, this._templates);

  @override

  /// Actually write out the documentation for [packageGraph].
  /// Stores the HtmlGeneratorInstance so we can access it in [writtenFiles].
  Future generate(PackageGraph packageGraph, String outputDirectoryPath) async {
    assert(_instance == null);

    var enabled = true;
    void write(String filePath, Object content, {bool allowOverwrite}) {
      allowOverwrite ??= false;
      if (!enabled) {
        throw new StateError('`write` was called after `generate` completed.');
      }
      // If you see this assert, we're probably being called to build non-canonical
      // docs somehow.  Check data.self.isCanonical and callers for bugs.
      assert(allowOverwrite || !writtenFiles.contains(filePath));

      var file = new File(path.join(outputDirectoryPath, filePath));
      var parent = file.parent;
      if (!parent.existsSync()) {
        parent.createSync(recursive: true);
      }

      if (content is String) {
        file.writeAsStringSync(content);
      } else if (content is List<int>) {
        file.writeAsBytesSync(content);
      } else {
        throw new ArgumentError.value(
            content, 'content', '`content` must be `String` or `List<int>`.');
      }
      _onFileCreated.add(file);
      writtenFiles.add(filePath);
    }

    try {
      _instance =
          new HtmlGeneratorInstance(_options, _templates, packageGraph, write);
      await _instance.generate();
    } finally {
      enabled = false;
    }
  }
}

class HtmlGeneratorOptions implements HtmlOptions {
  final String url;
  final String faviconPath;
  final bool prettyIndexJson;

  @override
  final String relCanonicalPrefix;

  @override
  final String toolVersion;

  HtmlGeneratorOptions(
      {this.url,
      this.relCanonicalPrefix,
      this.faviconPath,
      String toolVersion,
      this.prettyIndexJson = false})
      : this.toolVersion = toolVersion ?? 'unknown';
}

Uri _sdkFooterCopyrightUri;
Future<void> _setSdkFooterCopyrightUri() async {
  if (_sdkFooterCopyrightUri == null) {
    _sdkFooterCopyrightUri = await Isolate.resolvePackageUri(
        Uri.parse('package:dartdoc/resources/sdk_footer_text.html'));
  }
}

abstract class GeneratorContext implements DartdocOptionContext {
  String get favicon => optionSet['favicon'].valueAt(context);
  List<String> get footer => optionSet['footer'].valueAt(context);

  /// _footerText is only used to construct synthetic options.
  // ignore: unused_element
  List<String> get _footerText => optionSet['footerText'].valueAt(context);
  List<String> get footerTextPaths =>
      optionSet['footerTextPaths'].valueAt(context);
  List<String> get header => optionSet['header'].valueAt(context);
  String get hostedUrl => optionSet['hostedUrl'].valueAt(context);
  bool get prettyIndexJson => optionSet['prettyIndexJson'].valueAt(context);
  String get relCanonicalPrefix =>
      optionSet['relCanonicalPrefix'].valueAt(context);
}

Future<List<DartdocOption>> createGeneratorOptions() async {
  await _setSdkFooterCopyrightUri();
  return <DartdocOption>[
    new DartdocOptionArgFile<String>('favicon', null,
        isFile: true,
        help: 'A path to a favicon for the generated docs.',
        mustExist: true),
    new DartdocOptionArgFile<List<String>>('footer', [],
        isFile: true,
        help: 'paths to footer files containing HTML text.',
        mustExist: true,
        splitCommas: true),
    new DartdocOptionArgFile<List<String>>('footerText', [],
        isFile: true,
        help:
            'paths to footer-text files (optional text next to the package name '
            'and version).',
        mustExist: true,
        splitCommas: true),
    new DartdocOptionSyntheticOnly<List<String>>(
      'footerTextPaths',
      (DartdocSyntheticOption<List<String>> option, Directory dir) {
        final List<String> footerTextPaths = <String>[];
        final PackageMeta topLevelPackageMeta =
            option.root['topLevelPackageMeta'].valueAt(dir);
        // TODO(jcollins-g): Eliminate special casing for SDK and use config file.
        if (topLevelPackageMeta.isSdk == true) {
          footerTextPaths
              .add(path.canonicalize(_sdkFooterCopyrightUri.toFilePath()));
        }
        footerTextPaths.addAll(option.parent['footerText'].valueAt(dir));
        return footerTextPaths;
      },
      isFile: true,
      help: 'paths to footer-text-files (adding special case for SDK)',
      mustExist: true,
    ),
    new DartdocOptionArgFile<List<String>>('header', [],
        isFile: true,
        help: 'paths to header files containing HTML text.',
        splitCommas: true),
    new DartdocOptionArgOnly<String>('hostedUrl', null,
        help:
            'URL where the docs will be hosted (used to generate the sitemap).'),
    new DartdocOptionArgOnly<bool>('prettyIndexJson', false,
        help:
            "Generates `index.json` with indentation and newlines. The file is larger, but it's also easier to diff.",
        negatable: false),
    new DartdocOptionArgOnly<String>('relCanonicalPrefix', null,
        help:
            'If provided, add a rel="canonical" prefixed with provided value. '
            'Consider using if\nbuilding many versions of the docs for public '
            'SEO; learn more at https://goo.gl/gktN6F.'),
  ];
}
