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
import 'package:fast/config_storage.dart';

import '../../logger.dart';
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
    await configStorage.setValue(ConfigKeys.templatesPath, templatesPath);
    logger.d('Path to templates successfully configured.');
  }
}

class ConfigProjectsPathCommand extends CommandBase {
  @override
  String get description => 'Config the scaffolds path.';
  @override
  String get name => 'scaffolds';

  @override
  Future<void> run() async {
    validate(Contract('', ''));
    var scaffoldPath = argResults.rest[0];
    var configStorage = ConfigStorage();
    await configStorage.setValue(ConfigKeys.scaffoldsPath, scaffoldPath);
    logger.d('Path to scaffolds successfully configured.');
  }
}

class ConfigCommandsPathCommand extends CommandBase {
  @override
  String get description => 'Config the commands file path.';
  @override
  String get name => 'commands';

  @override
  Future<void> run() async {
    validate(Contract('', ''));
    var configStorage = ConfigStorage();
    var commandsPath = argResults.rest[0];
    await configStorage.setValue(ConfigKeys.commandsFilePath, commandsPath);
    logger.d('Path to commands file successfully configured.');
  }
}
