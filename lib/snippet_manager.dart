import 'dart:convert';
import 'dart:io';

import 'package:fast/yaml_manager.dart';
import 'package:path/path.dart';
import 'core/directory.dart';

class ReplacerSnippet {
  RegExp regex;
  final String argName;
  String value;

  ReplacerSnippet(this.argName, [this.value]) {
    regex = RegExp('@$argName');
  }

  String replace(String string) {
    if (regex.hasMatch(string)) {
      return string.replaceAllMapped(regex, (mathe) => value);
    }

    return string;
  }
}

List<ReplacerSnippet> createSnipReplacers(List<String> args) {
  final replacers = <ReplacerSnippet>[];

  var index = 1;
  for (var i = 0; i < args.length; i++) {
    final arg = args[i];
    final argUpperCase = '${arg[0].toUpperCase()}${arg.substring(1)}';
    replacers.add(ReplacerSnippet('$arg', '\${${index.toString()}:$arg}'));
    index++;
    replacers.add(
        ReplacerSnippet(argUpperCase, '\${${index.toString()}:$argUpperCase}'));
    index++;
  }

  return replacers;
}

String replacerSnipLine(String line, List<ReplacerSnippet> replacers) {
  var newContent = line;
  for (var replacer in replacers) {
    newContent = replaceSnipData(newContent, replacer);
  }

  return newContent;
}

String replaceSnipData(String content, ReplacerSnippet replacer) {
  String replaced;
  final contains = replacer.regex.hasMatch(content);
  if (contains) {
    replaced =
        content.replaceAllMapped(replacer.regex, (mathe) => replacer.value);
  }

  if (replaced == null) return content;
  return replaced;
}

class SnippetFile {
  String fileName;
  final String prefix;
  final List<int> excluded;
  List<String> contentLines;
  List<String> snippetContent;
  List<String> body = <String>[];
  String extension;
  String path;

  SnippetFile(
      {this.prefix,
      this.excluded,
      this.fileName,
      this.path,
      this.contentLines,
      this.extension}) {
    snippetContent = [];
  }

  void createBody(List<ReplacerSnippet> replacers) {
    final linesReplaced = <String>[];

    for (final line in contentLines) {
      var lineReplaced = line;
      for (var replacer in replacers) {
        lineReplaced = replaceSnipData(lineReplaced, replacer);
      }
      linesReplaced.add(lineReplaced);
    }

    snippetContent = linesReplaced;
    _addspaces();
  }

  void _addspaces() async {
    final body = <String>[];
    for (var i = 0; i < snippetContent.length; i++) {
      if (!excluded.contains(i)) {
        body.add('${snippetContent[i]}');
      }
    }
  }
}

class SnippetGenerator {
  final List<Template> templates;
  final String templatesPath;
  final String globalSnippetsPath;
  final Map<dynamic, dynamic> _snippetsData = {};

  SnippetGenerator(this.templates, this.templatesPath, this.globalSnippetsPath);

  void generateSnippedFile() async {
    await _createSnippets();
    await _createGlobalSnippedFile();
  }

  void _createGlobalSnippedFile() async {
    var snippedFile = File(globalSnippetsPath);
    await snippedFile.create(recursive: true);
    await snippedFile.writeAsString(json.encode(_snippetsData));
  }

  Future<List<SnippetFile>> _loadSnippetFiles(Template template) async {
    final directory =
        Directory(normalize('${templatesPath}/${template.name}_template'));
    final files = await directory.getAllSystemFiles();
    final snippetFiles = <SnippetFile>[];

    for (var file in files) {
      final content = await (file as File).readAsLines();
      final fileName = split(file.path).last;
      final templateFileSnippet = template.templateSnippets
          .firstWhere((item) => item.fileName == fileName, orElse: () => null);

      if (templateFileSnippet != null) {
        snippetFiles.add(SnippetFile(
            excluded: templateFileSnippet.excludeLines,
            prefix: templateFileSnippet.prefix,
            fileName: fileName,
            contentLines: content,
            path: file.path,
            extension: extension(file.path)));
      }
    }
    return snippetFiles;
  }

  void _createSnippets() async {
    for (var template in templates) {
      final snippetFiles = await _loadSnippetFiles(template);
      final codeSnippets = <CodeSnippet>[];

      for (final snippetFile in snippetFiles) {
        snippetFile.createBody(createSnipReplacers(template.args));
        codeSnippets.add(CodeSnippet('${snippetFile.prefix}',
            snippetConfig: SnippetConfig(
                scope: 'dart',
                prefix: '${snippetFile.prefix}',
                description: 'test',
                body: snippetFile.body)));
      }

      for (final codeSnippet in codeSnippets) {
        _snippetsData[codeSnippet.name] = codeSnippet.toJson();
      }
    }
  }
}

class CodeSnippet {
  SnippetConfig snippetConfig;
  final String name;
  CodeSnippet(this.name, {this.snippetConfig});

  Map<String, dynamic> toJson() {
    return snippetConfig.toJson();
  }
}

class SnippetConfig {
  String scope;
  String prefix;
  List<String> body;
  String description;

  SnippetConfig({this.scope, this.prefix, this.body, this.description});

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['scope'] = scope;
    data['prefix'] = prefix;
    data['body'] = body;
    data['description'] = description;
    return data;
  }
}
