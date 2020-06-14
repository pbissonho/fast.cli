//Copyright 2020 Pedro Bissonho
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

import 'dart:io';

import 'package:path/path.dart';
import 'package:tena/core/action.dart';
import 'package:tena/yaml_manager.dart';
import '../core/directory/directory.dart';

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

class CreateTemplateAction implements Action {
  final Template template;
  Directory _templateFolderPath;
  final Map<String, String> argsMap;

  final templateFiles = <TemplateFile>[];

  CreateTemplateAction(this.template, String templateFolderPath, this.argsMap) {
    _templateFolderPath = Directory(templateFolderPath);
  }

  @override
  Future<void> execute() async {
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
  }

  @override
  String get actionName => 'Create template action.';
}
