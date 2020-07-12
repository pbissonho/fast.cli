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
import 'core/home_path.dart';

class PluginRepository {
  List<Plugin> getAll(Map<String, dynamic> json) {
    var models = <Plugin>[];
    if (json['plugins'] != null) {
      json['plugins'].forEach((v) {
        models.add(Plugin.fromJson(v));
      });
    }
    return models;
  }

  Map<String, dynamic> toStorage(List<Plugin> models) {
    final data = <String, dynamic>{};
    if (models != null) {
      data['plugins'] = models.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Plugin {
  String name;
  String path;
  String git;

  Plugin({this.name, this.path, this.git});

  bool isGit() {
    return git.isNotEmpty;
  }

  Plugin.fromJson(Map<String, dynamic> json) {
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

// Manages resources of the plugins that will be added to the project.
// Provides methods for adding and removing lugins.
class PluginStorage {
  String _filePath = '${homePath()}/.fastcli/plugins.json';

  PluginStorage([String filePath]) {
    if (filePath != null) _filePath = filePath;
  }

  Future<Plugin> readByName(String name) async {
    var plugin = await read();
    return plugin.firstWhere((element) => element.name == name);
  }

  Future<List<Plugin>> read() async {
    var file = File(_filePath);
    Map<String, dynamic> data;
    if (!await file.exists()) {
      return <Plugin>[];
    }

    var fileContents = await file.readAsString();
    if (fileContents.isEmpty) {
      return <Plugin>[];
    }

    data = await json.decode(fileContents);
    var plugins = PluginRepository().getAll(data);
    return plugins;
  }

  Future<void> write(List<Plugin> plugin) async {
    var file = File(_filePath);
    if (!await file.exists()) {
      await file.create();
    }
    var data = PluginRepository().toStorage(plugin);
    await file.writeAsString(json.encode(data));
  }

  Future<void> add(Plugin model) async {
    var plugins = await read();
    plugins.removeWhere((element) => element.name == model.name);
    plugins.add(model);
    await write(plugins);
  }

  Future<void> remove(String name) async {
    var plugins = await read();
    plugins.removeWhere((element) => element.name == name);
    await write(plugins);
  }
}
