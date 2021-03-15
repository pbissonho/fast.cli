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
import 'package:yaml/yaml.dart';
import 'core/exceptions.dart';
import 'yaml_reader.dart';

class YamlScaffoldKeys {
  static String commandsKey = 'commands';
  static String structureKey = 'structure';
  static String testStructureKey = 'test_structure';
  static String dependenciesKey = 'dependencies';
  static String dev_dependenciesKey = 'dev_dependencies';
  static String copy_filesKey = 'copy_files';
}

class YamlCommand {
  final String key;
  final String command;

  YamlCommand(this.key, this.command);
}

class Dependency {
  final String name;
  String version;

  Dependency(this.name, [this.version]) {
    version ??= '';
  }
}

class YamlDependencies {
  static List<Dependency> readDependencies(String key, YamlReader reader) {
    final yamldata = reader.reader();
    final dependencies = <Dependency>[];
    final dependenciesData = yamldata[key] as Map;
    dependenciesData.forEach((key, comand) {
      dependencies.add(Dependency(key, comand));
    });

    return dependencies;
  }
}

class Structure {
  final List data;
  final mainFolder = Folder('src');

  Structure(this.data) {
    createStructure(data, mainFolder);
  }

  void createStructure(dynamic data, Folder parent) {
    if (data is YamlList) {
      data.forEach((folderName) {
        createStructure(folderName, parent);
      });
    }

    if (data is YamlMap) {
      data.forEach((key, childData) {
        final folder = Folder(key);
        parent.addSubFolder(folder);
        createStructure(childData, folder);
      });
    }

    if (data is String) {
      final splited = data.split('.');

      if (splited.length == 1) {
        parent.addSubFolder(Folder(data));
      } else {
        parent.addFile(YamlFile(data));
      }
    }
  }
}

class Folder {
  final String name;
  final List<Folder> subFolders = <Folder>[];
  final List<YamlFile> files = <YamlFile>[];

  Folder(this.name);

  void addSubFolder(Folder folder) {
    subFolders.add(folder);
  }

  void addFile(YamlFile file) {
    files.add(file);
  }
}

class YamlFile {
  final String name;
  final String content;
  final String extension;

  YamlFile(this.name, {this.content, this.extension});
}

class Template {
  final String name;
  final String description;
  final String to;
  final List<String> args;
  final List<TemplateSnippet> templateSnippets;
  final String path;

  bool hasSnippets() {
    return templateSnippets != null;
  }

  Template({
    this.path,
    this.description,
    this.name,
    this.to,
    this.args,
    this.templateSnippets,
  });
}

class TemplateSnippet {
  final String fileName;
  final String prefix;
  final List<int> excludeLines;

  TemplateSnippet({this.fileName, this.prefix, this.excludeLines});
}

class Scaffold {
  final String name;
  final Structure structure;
  final Structure testStructure;
  final bool copyFiles;

  Scaffold(
      {this.structure, this.testStructure, this.name, this.copyFiles = false});
}

// A predefined set of resources.
class YamlPlugin {
  final String name;
  final String description;

  YamlPlugin({this.name, this.description});
}

class YamlManager {
  static List<Template> loadTemplates(String folder) {
    final templates = <Template>[];

    final directory = Directory(folder);
    directory.listSync().forEach((element) {
      templates
          .add(YamlTemplateReader('${element.path}/template.yaml').reader());
    });

    return templates;
  }

  static List<Scaffold> loadScaffolds(String folder) {
    final scaffolds = <Scaffold>[];

    final directory = Directory(folder);
    directory.listSync().forEach((element) {
      var Scaffold = readerYamlScaffoldFile('${element.path}/scaffold.yaml');
      scaffolds.add(Scaffold);
    });

    return scaffolds;
  }

  static Scaffold loadScaffold(String folderPath) {
    final directory = Directory(folderPath);
    final scaffold = readerYamlScaffoldFile('${directory.path}/scaffold.yaml');
    return scaffold;
  }

  static List<YamlCommand> readerYamlCommandsFile(String yamlPath) {
    final yamlCommands = <YamlCommand>[];
    final reader = YamlReader(yamlPath);
    final yamldata = reader.reader();
    final yamlCommandsData = yamldata[YamlScaffoldKeys.commandsKey] as Map;
    yamlCommandsData.forEach((key, comand) {
      yamlCommands.add(YamlCommand(key, comand));
    });

    return yamlCommands;
  }

  static Scaffold readerYamlScaffoldFile(String yamlPath) {
    final reader = YamlReader(yamlPath);
    dynamic structureData;
    final yamldata = reader.reader();

    structureData = yamldata[YamlScaffoldKeys.structureKey];
    final structure = Structure(structureData);
    final name = yamldata['name'];
    final testStructureData = yamldata[YamlScaffoldKeys.testStructureKey];
    final testStructure = Structure(testStructureData);
    final copyFiles = yamldata[YamlScaffoldKeys.copy_filesKey];

    return Scaffold(
      name: name,
      structure: structure,
      testStructure: testStructure,
      copyFiles: copyFiles,
    );
  }

  static YamlPlugin readerYamlPluginFile(String yamlPath) {
    final reader = YamlReader(yamlPath);
    final yamldata = reader.reader();

    final name = yamldata['name'];
    final description = yamldata['description'];

    return YamlPlugin(
      name: name,
      description: description,
    );
  }
}

class YamlTemplateReader {
  final String path;
  YamlReader yamlReader;

  YamlTemplateReader(this.path) {
    yamlReader = YamlReader(path);
  }

  Template reader() {
    try {
      final yamlData = yamlReader.reader();
      final args =
          (yamlData['args'] as YamlList).map((value) => '$value').toList();

      YamlList snippetsData;
      final snippets = <TemplateSnippet>[];

      try {
        snippetsData = (yamlData['snippets'] as YamlList);
        final listSnippetsData = snippetsData.toList();

        for (var item in listSnippetsData) {
          final mapData = (item as YamlMap);
          final templateSnippet = TemplateSnippet(
              fileName: mapData['file'],
              prefix: mapData['prefix'],
              excludeLines: (mapData['excluded'] as YamlList)
                  .map<int>((f) => f)
                  .toList());
          snippets.add(templateSnippet);
        }
      } catch (erro) {
        return Template(
          path: dirname(path),
          name: yamlData['name'],
          to: yamlData['to'],
          args: args,
          description: yamlData['description'],
        );
      }

      return Template(
          path: dirname(path),
          name: yamlData['name'],
          to: yamlData['to'],
          args: args,
          description: yamlData['description'],
          templateSnippets: snippets);
    } catch (error) {
      throw FastException('''
An error occurred while reading the template $path's file.
Check that the yaml file has been written correctly.
Error: $error
      ''');
    }
  }
}
