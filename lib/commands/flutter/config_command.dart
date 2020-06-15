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

import 'package:flunt_dart/flunt_dart.dart';
import 'package:tena/config_storage.dart';

import '../command_base.dart';

class ConfigCommand extends CommandBase {
  @override
  String get description => 'Config the template path.';
  @override
  String get name => 'config';

  ConfigCommand() {
    addSubcommand(ConfigTemplatesPathCommand());
    addSubcommand(ConfigProjectsPathCommand());
    addSubcommand(ConfigCommandsPathCommand());
  }
}

class ConfigTemplatesPathCommand extends CommandBase {
  @override
  String get description => 'Config the template path.';
  @override
  String get name => 'templates';

  @override
  Future<void> run() async {
    validate(Contract('', ''));
    var templatesPath = argResults.rest[0];
    var configStorage = ConfigStorage();

    await ConfigStorage().setConfig(TenaConfig(
        scaffoldsPath:
            await configStorage.getConfigByKeyOrBlank(ConfigKeys.scaffoldsPath),
        templatesPath: templatesPath,
        commandsFilePath: await configStorage
            .getConfigByKeyOrBlank(ConfigKeys.commandsFilePath)));
  }
}

class ConfigProjectsPathCommand extends CommandBase {
  @override
  String get description => 'Config the template path.';
  @override
  String get name => 'scaffold';

  @override
  Future<void> run() async {
    validate(Contract('', ''));
    var scaffoldPath = argResults.rest[0];
    var configStorage = ConfigStorage();

    await ConfigStorage().setConfig(TenaConfig(
        scaffoldsPath: scaffoldPath,
        templatesPath:
            await configStorage.getConfigByKeyOrBlank(ConfigKeys.templatesPath),
        commandsFilePath: await configStorage
            .getConfigByKeyOrBlank(ConfigKeys.commandsFilePath)));
  }
}

class ConfigCommandsPathCommand extends CommandBase {
  @override
  String get description => 'Config the template path.';
  @override
  String get name => 'commands';

  @override
  Future<void> run() async {
    validate(Contract('', ''));
    var configStorage = ConfigStorage();
    var commandsPath = argResults.rest[0];

    await ConfigStorage().setConfig(TenaConfig(
        scaffoldsPath:
            await configStorage.getConfigByKeyOrBlank(ConfigKeys.scaffoldsPath),
        templatesPath:
            await configStorage.getConfigByKeyOrBlank(ConfigKeys.templatesPath),
        commandsFilePath: commandsPath));
  }
}
