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

import 'package:fast/actions/plugin_add_git_action.dart';
import 'package:fast/bash_manager.dart';
import 'package:fast/config_storage.dart';
import 'package:fast/windows_manager.dart';
import 'package:fast/yaml_manager.dart';
import 'package:flunt_dart/flunt_dart.dart';

import '../logger.dart';
import 'command_base.dart';

class PluginCommand extends CommandBase {
  final PluginStorage storage;
  BashFileManager bashFileManager;

  @override
  String get description => 'Managed plugins.';

  @override
  String get name => 'plugin';

  PluginCommand(this.storage) {
    BashFileManager bashFileManager;
    var storage = PluginStorage() ;
    if (Platform.isLinux || Platform.isMacOS) {
      bashFileManager = BashFileManager();
    } else if (Platform.isWindows) {
      bashFileManager = WindowsManager();
    }

    addSubcommand(AddCommand(bashFileManager, storage,
        PluginAddGitAction(storage, bashFileManager)));
    addSubcommand(RemovePluginCommand(PluginStorage(), bashFileManager));
    addSubcommand(ListPluginCommand(PluginStorage()));
  }
}

class AddCommand extends CommandBase {
  final BashFileManager fileManager;
  final PluginStorage storage;
  final PluginAddGitAction addGitAction;

  @override
  String get description => 'Adds a plugin resources';

  @override
  String get name => 'add';

  AddCommand(this.fileManager, this.storage, this.addGitAction) {
    argParser.addOption('source', allowed: ['path', 'git']);
  }

  @override
  Future<void> run() async {
    var source = argResults['source'];

    if (source == 'path') {
      var path = argResults.rest[0];
      await AddPathCommand(storage, fileManager).run(path);
    } else {
      var url = argResults.rest[0];
      var path = argResults.rest[1];
      await AddGitCommand(addGitAction).run(url, path);
    }
  }
}

class AddPathCommand {
  final PluginStorage storage;
  final BashFileManager bashFileManager;

  String get description => 'Adds a plugin resources from path';

  String get name => 'path';

  AddPathCommand(this.storage, this.bashFileManager);

  Future<void> run(String path) async {
    var yamlPluginFile = YamlManager.readerYamlPluginFile('$path/plugin.yaml');
    var plugin = Plugin(git: '', path: path, name: yamlPluginFile.name);
    await storage.add(plugin);
    await bashFileManager.createExecutable(yamlPluginFile.name);
    logger.d(
        'Plugin(${yamlPluginFile.name}) - Resources successfully configured.');
    logger.d('Executable: ${yamlPluginFile.name} - Globally configured');
  }
}

class AddGitCommand {
  final PluginAddGitAction action;

  String get description => 'Adds a plugin resources from git';

  String get name => 'git';

  AddGitCommand(this.action);

  Future<void> run(String gitUrl, String path) async {
    action.setUrl(gitUrl);
    action.withPath(path);
    logger.d('Installing plugin...');
    await action.execute();
  }
}

class RemovePluginCommand extends CommandBase {
  final PluginStorage storage;
  final BashFileManager bashFileManager;

  @override
  String get description => 'Remove a plugin resources';

  @override
  String get name => 'remove';

  RemovePluginCommand(this.storage, this.bashFileManager) {
    argParser.addOption('name');
  }

  @override
  Future<void> run() async {
    var pluginName = argResults['name'];

    validate(
        Contract<String>(pluginName, 'name')..isNotNull('Must be passed.'));

    var model = await storage.readByName(pluginName);
    await storage.remove(pluginName);
    await bashFileManager.removeExecutable(pluginName);
    await bashFileManager.removeCachedRepository(model.path);
    logger.d('Plugin removed successfully.');
  }
}

class UpdatePluginCommand extends CommandBase {
  final PluginStorage storage;

  @override
  String get description => 'Upate all git plugins';

  @override
  String get name => 'update';

  UpdatePluginCommand(this.storage);

  @override
  Future<void> run() async {
    // TODO
  }
}

class ListPluginCommand extends CommandBase {
  final PluginStorage storage;

  @override
  String get description => 'Upate all git plugins';

  @override
  String get name => 'list';

  ListPluginCommand(this.storage);

  @override
  Future<void> run() async {
    var plugins = await storage.read();

    logger.d('Installed plugins:');
    plugins.forEach((plugin) {
      logger.d('${plugin.name} - git: ${plugin.git}');
    });
  }
}
