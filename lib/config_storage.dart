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

import 'core/exceptions.dart';
import 'core/home_path.dart';

class ConfigKeys {
  static const String templatesPath = 'templatesPath';
  static const String scaffoldsPath = 'scaffoldsPath';
  static const String commandsFilePath = 'commandsFilePath';
}

class CliModels {
  List<CliModel> models;

  CliModels({this.models});

  CliModels.fromJson(Map<String, dynamic> json) {
    if (json['test'] != null) {
      models = <CliModel>[];
      json['test'].forEach((v) {
        models.add(CliModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (models != null) {
      data['test'] = models.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CliModel {
  String name;
  String path;
  String git;

  CliModel({this.name, this.path, this.git});

  CliModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    path = json['path'];
    git = json['git'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['path'] = path;
    data['git'] = git;
    return data;
  }
}

// Manages resources of the CLIs that will be added to the project.
// Provides methods for adding and removing CLIs.
class CliConfigStorage {
  String _filePath = '${homePath()}/.fast_clis.json';

  CliConfigStorage([String filePath]) {
    if (filePath != null) _filePath = filePath;
  }
  
  Future<CliModel> readByName(String name) async {
    var models = await read();
    return models.models.firstWhere((element) => element.name == name);
  }

  Future<CliModels> read() async {
    var file = File(_filePath);
    Map<String, dynamic> data;
    if (!await file.exists()) {
      return CliModels(models: []);
    }

    var fileContents = await file.readAsString();
    if (fileContents.isEmpty) {
      return CliModels(models: []);
    }

    data = await json.decode(fileContents);
    var cliModels = CliModels.fromJson(data);
    return cliModels;
  }

  Future<void> write(CliModels cliModels) async {
    var file = File(_filePath);
    if (!await file.exists()) {
      await file.create();
    }
    await file.writeAsString(json.encode(cliModels.toJson()));
  }

  Future<void> addCli(CliModel model) async {
    var current = await read();
    current.models.removeWhere((element) => element.name == model.name);
    current.models.add(model);
    await write(current);
  }

  Future<void> removeCli(String name) async {
    var current = await read();
    current.models.removeWhere((element) => element.name == name);
    await write(current);
  }
}

class ConfigStorage {
  String _filePath = '${homePath()}/.fast.json';

  ConfigStorage([String filePath]) {
    if (filePath != null) _filePath = filePath;
  }

  Future setValue(String key, String value) async {
    var file = File(_filePath);
    Map<String, dynamic> data;
    if (!await file.exists()) {
      data = {};
    } else {
      var fileContents = await file.readAsString();
      if (fileContents.isEmpty) {
        data = {};
      } else {
        data = await json.decode(fileContents) as Map;
      }
    }
    data[key] = value;
    await _updateFile(data);
  }

  Future<String> getValue(String key) async {
    var file = File(_filePath);
    dynamic data;
    if (!await file.exists() || await file.readAsString.toString().isEmpty) {
      throw FastException('''
Before using you must configure the paths of the resources.
It is necessary to configure the paths of the resources correctly.
Visit https://github.com/pbissonho/fast.cli#config to learn how to configure.
          ''');
    }
    try {
      var fileContents = await file.readAsString();
      data = await json.decode(fileContents);
      return data[key];
    } catch (error) {
      throw FastException('''
An error occurred while decode $key value.
It is necessary to configure the paths of the resources correctly.
Please make sure you have set a valid value for $key.
Visit https://github.com/pbissonho/fast.cli#config to learn how to configure.
          ''');
    }
  }

  Future _updateFile(Map<String, dynamic> data) async {
    var file = File(_filePath);
    bool exists;
    exists = await file.exists();
    if (!exists) {
      await file.create();
    }

    var writeData = json.encode(data);
    await file.writeAsString(writeData);
  }
}
