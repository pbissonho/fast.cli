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
import 'package:fast/core/action.dart';
import 'package:fast/yaml_manager.dart';
import 'package:path/path.dart';

import '../core/directory.dart';
import '../replacer.dart';

class TemplateFile {
  String name;
  String content;
  String extension;
  String path;

  TemplateFile({this.name, this.path, this.content, this.extension});
}

class CreateTemplateAction implements Action {
  final Template template;
  Directory _templateFolderDirectory;
  final Map<String, String> argsMap;
  List<TemplateFile> templateFiles;
  CreateTemplateAction(this.template, this.argsMap) {
    _templateFolderDirectory = Directory(template.path);
  }

  @override
  Future<void> execute() async {
    final templateFiles = await readerTemplatesFiles();
    replacerTemplatesFile(argsMap, templateFiles);

    for (final template in templateFiles) {
      if (template.extension.toLowerCase() != '.yaml') {
        final file = File(template.path);
        await file.create(recursive: true);
        await file.writeAsString(template.content);
      }
    }
  }

  Future<List<TemplateFile>> readerTemplatesFiles() async {
    final templatesFile = <TemplateFile>[];
    final systemFiles = await _templateFolderDirectory.getAllSystemFiles();

    for (final systemFile in systemFiles) {
      if (systemFile is File) {
        final content = await systemFile.readAsString();

        final relativePath = relative(systemFile.path, from: template.path);
        final filePath = normalize('${template.to}/$relativePath');

        templatesFile.add(TemplateFile(
            name: split(systemFile.path).last,
            content: content,
            path: filePath,
            extension: extension(systemFile.path)));
      }
    }
    return templatesFile;
  }

  void replacerTemplatesFile(
      Map<String, String> argsMap, List<TemplateFile> templateFiles) {
    final replacers = createReplacers(argsMap);

    for (final templateFile in templateFiles) {
      for (final replacer in replacers) {
        templateFile.name = replaceData(templateFile.name, replacer);
        templateFile.content = replaceData(templateFile.content, replacer);
        templateFile.path = replaceData(templateFile.path, replacer);
        templateFile.extension = templateFile.extension;
      }
    }
  }

  @override
  String get succesMessage => 'Create template action.';
}
