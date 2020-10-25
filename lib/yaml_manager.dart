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

import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';
import 'config_storage.dart';
import 'core/exceptions.dart';
import 'yaml_reader.dart';

class YamlScaffoldKeys {
  static String commandsKey = 'commands';
  static String structureKey = 'lib_structure';
  static String testStructureKey = 'test_structure';
  static String dependenciesKey = 'dependencies';
  static String dev_dependenciesKey = 'dev_dependencies';
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
    var yamldata = reader.reader();
    var dependencies = <Dependency>[];
    var dependenciesData = yamldata[key] as Map;
    dependenciesData.forEach((key, comand) {
      dependencies.add(Dependency(key, comand));
    });

    return dependencies;
  }
}

class Structure {
  Structure(this.data, this.mainFolderName) {
    createStructure(data, mainFolder);
  }
  final List data;
  final String mainFolderName;

  var mainFolder = Folder('src');

  void createStructure(dynamic data, Folder parent) {
    if (data is List) {
      data.forEach((folderName) {
        createStructure(folderName, parent);
      });
    }

    if (data is Map) {
      data.forEach((key, childData) {
        var folder = Folder(key);
        parent.addSubFolder(folder);
        createStructure(childData, folder);
      });
    }

    // parent.add(Folder(data));

    if (data is String) {
      var splited = data.split('.');

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
  List<Folder> subFolders = <Folder>[];
  List<YamlFile> files = <YamlFile>[];

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
  final List<String> sets;

  Scaffold({
    this.structure,
    this.testStructure,
    this.name,
    this.sets,
  });
}

// A predefined set of resources.
class YamlPlugin {
  final String name;
  final String description;

  YamlPlugin({this.name, this.description});
}

class YamlManager {
  static List<Template> loadTemplates(String folder) {
    var templates = <Template>[];

    var dir = Directory(folder);
    dir.listSync().forEach((element) {
      templates
          .add(YamlTemplateReader('${element.path}/template.yaml').reader());
    });

    return templates;
  }

  static List<YamlCommand> readerYamlCommandsFile(String yamlPath) {
    var yamlCommands = <YamlCommand>[];
    var reader = YamlReader(yamlPath);
    var yamldata = reader.reader();
    var yamlCommandsData = yamldata[YamlScaffoldKeys.commandsKey] as Map;
    yamlCommandsData.forEach((key, comand) {
      yamlCommands.add(YamlCommand(key, comand));
    });

    return yamlCommands;
  }

  static YamlPlugin readerYamlPluginFile(String yamlPath) {
    var reader = YamlReader(yamlPath);
    var yamldata = reader.reader();

    var name = yamldata['name'];
    var description = yamldata['description'];

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
      var yamlData = yamlReader.reader();
      var args =
          (yamlData['args'] as YamlList).map((value) => '$value').toList();

      YamlList snippetsData;
      var snippets = <TemplateSnippet>[];

      try {
        snippetsData = (yamlData['snippets'] as YamlList);
        var listSnippetsData = snippetsData.toList();

        for (var item in listSnippetsData) {
          var mapData = (item as YamlMap);
          var templateSnippet = TemplateSnippet(
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

class ScaffoldReader {
  final Plugin plugin;

  ScaffoldReader(this.plugin);

  Future<Scaffold> loadScaffold(String scaffoldName) async {
    Scaffold scaffold;
    scaffold = await readerYamlScaffoldFile(scaffoldName, plugin.path);
    return scaffold;
  }

  static Future<Scaffold> readerYamlScaffoldFile(
      String scaffoldName, String pluginPath) async {
    var scaffoldYamlData =
        await readerYaml('${pluginPath}/scaffolds/$scaffoldName.yaml');
    final structuresContent =
        await File('${pluginPath}/structures.yaml').readAsStringSync();

    final structuresMap = json.decode(json.encode(loadYaml(structuresContent)))
        as Map<String, dynamic>;

    final structureName = scaffoldYamlData[YamlScaffoldKeys.structureKey];
    final name = scaffoldYamlData['name'];
    var testStructureName = scaffoldYamlData[YamlScaffoldKeys.testStructureKey];

    var scaffoldDataMap =
        json.decode(json.encode(scaffoldYamlData)) as Map<String, dynamic>;
    return Scaffold(
      sets: (scaffoldDataMap['sets'] as List).map((e) => '$e').toList(),
      name: name,
      structure: Structure(structuresMap[structureName], 'src'),
      testStructure: Structure(structuresMap[testStructureName], 'src'),
    );
  }
}

class StructureReader {
  final Plugin plugin;

  StructureReader(this.plugin);

  Future<Structure> reader(String structureName, String to) async {
    final structuresContent =
        await File('${plugin.path}/structures.yaml').readAsStringSync();

    final structuresMap = json.decode(json.encode(loadYaml(structuresContent)))
        as Map<String, dynamic>;
    return Structure(structuresMap[structureName], to);
  }
}
