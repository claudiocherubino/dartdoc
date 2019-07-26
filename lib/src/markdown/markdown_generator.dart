library dartdoc.makrdown_generator;

import 'dart:async';
import 'dart:io' show Directory, File;

import 'package:dartdoc/src/generator.dart';
import 'package:dartdoc/src/logging.dart';
import 'package:dartdoc/src/model.dart';
import 'package:dartdoc/src/model_utils.dart';
import 'package:dartdoc/src/markdown/markdown_generator_instance.dart';
import 'package:dartdoc/src/markdown/template_data.dart';
import 'package:dartdoc/src/markdown/templates.dart';
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

class MarkdownGenerator extends Generator {
  final Templates _templates;
  final MarkdownGeneratorOptions _options;
  MarkdownGeneratorInstance _instance;

  final StreamController<void> _onFileCreated =
      new StreamController(sync: true);

  @override
  Stream<void> get onFileCreated => _onFileCreated.stream;

  @override
  final Set<String> writtenFiles = new Set<String>();

  static Future<MarkdownGenerator> create(
      {MarkdownGeneratorOptions options,
      List<String> headers,
      List<String> footers,
      List<String> footerTexts}) async {
    var templates = await Templates.create(
        headerPaths: headers,
        footerPaths: footers,
        footerTextPaths: footerTexts);

    return new MarkdownGenerator._(
        options ?? new MarkdownGeneratorOptions(), templates);
  }

  MarkdownGenerator._(this._options, this._templates);

  /// Actually write out the documentation for [packageGraph].
  /// Stores the MarkdownGeneratorInstance so we can access it in [writtenFiles].
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

      // TODO: this (and the validate step) should support a 'markdown' subfolder
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
          new MarkdownGeneratorInstance(_options, _templates, packageGraph, write);
      await _instance.generate();
    } finally {
      enabled = false;
    }
  }
}

class MarkdownGeneratorOptions implements MarkdownOptions {
  final String url;
  final bool prettyIndexJson;

  @override
  final String relCanonicalPrefix;

  @override
  final String toolVersion;

  MarkdownGeneratorOptions(
      {this.url,
      this.relCanonicalPrefix,
      String toolVersion,
      this.prettyIndexJson = false})
      : this.toolVersion = toolVersion ?? 'unknown';
}
