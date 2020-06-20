import 'dart:io';

import 'package:path/path.dart';
import 'core/directory/directory.dart';

class TemplateFile {
  String name;
  String content;
  String extension;
  String path;

  TemplateFile({this.name, this.path, this.content, this.extension});
}

class Replacer {
  RegExp regex;
  final String argName;
  String value;

  Replacer(this.argName, [this.value]) {
    regex = RegExp('@$argName');
  }

  String replace(String string) {
    if (regex.hasMatch(string)) {
      return string.replaceAllMapped(regex, (mathe) => value);
    }

    return string;
  }
}

List<Replacer> createReplacers(Map<String, String> args) {
  var replacers = <Replacer>[];

  args.forEach((arg, value) {
    replacers.add(Replacer('${arg[0].toUpperCase()}${arg.substring(1)}',
        '${value[0].toUpperCase()}${value.substring(1)}'));
    replacers.add(Replacer(arg, value));
  });

  return replacers;
}

String replacerFile(String content, List<Replacer> replacers) {
  var newContent = content;
  for (var replacer in replacers) {
    newContent = replaceData(newContent, replacer);
  }

  return newContent;
}

String replaceData(String content, Replacer replacer) {
  String replaced;
  var contains = replacer.regex.hasMatch(content);
  if (contains) {
    replaced =
        content.replaceAllMapped(replacer.regex, (mathe) => replacer.value);
  }

  if (replaced == null) return content;
  return replaced;
}

Future<List<TemplateFile>> createTemplatesReplacedsFile(
    Map<String, String> argsMap, Directory _templateFolderPath) async {
  final templateFiles = <TemplateFile>[];

  var replacers = createReplacers(argsMap);

  var files = await _templateFolderPath.getAllSystemFiles();

  for (var file in files) {
    var content = await (file as File).readAsString();

    templateFiles.add(TemplateFile(
        name: split(file.path).last,
        content: content,
        path: file.path,
        extension: extension(file.path)));
  }

  for (var templateFile in templateFiles) {
    for (var replacer in replacers) {
      templateFile.name = replaceData(templateFile.name, replacer);
      templateFile.content = replaceData(templateFile.content, replacer);
      templateFile.path = templateFile.path;
      templateFile.extension = templateFile.extension;
    }
  }
  return templateFiles;
}
