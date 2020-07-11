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

import 'package:fast/bash_manager.dart';
import 'package:fast/config_storage.dart';
import 'package:fast/yaml_manager.dart';

import '../logger.dart';
import 'command_base.dart';

class CliCommand extends CommandBase {
  @override
  String get description => 'Adds a CLI resources';

  @override
  String get name => 'add';

  CliCommand() {
    addSubcommand(CliAddPathCommand(CliConfigStorage(), BashFileManager()));
    addSubcommand(CliAddGitCommand(CliConfigStorage()));
  }
}

class CliAddPathCommand extends CommandBase {
  final CliConfigStorage storage;
  final BashFileManager bashFileManager;

  @override
  String get description => 'Adds a CLI resources';

  @override
  String get name => 'path';

  CliAddPathCommand(this.storage, this.bashFileManager);

  @override
  Future<void> run() async {
    var path = argResults.rest[0];
    var cliFile = YamlManager.readerCliFile('$path/cli.yaml');
    var model = CliModel(git: '', path: path, name: cliFile.name);
    await storage.addCli(model);
    await bashFileManager.createExecutable(cliFile.name);
    logger.d('CLI(${cliFile.name}) - Resources successfully configured.');
    logger.d('Executable: ${cliFile.name} - Globally configured');
  }
}

class CliAddGitCommand extends CommandBase {
  final CliConfigStorage storage;

  @override
  String get description => 'Adds a CLI resources';

  @override
  String get name => 'git';

  CliAddGitCommand(this.storage);

  @override
  Future<void> run() async {
    var gitUrl = argResults.rest[0];
    var model = CliModel(git: gitUrl, path: '', name: 'name');
    await storage.addCli(model);
  }
}

class CliRemoveGitCommand extends CommandBase {
  final CliConfigStorage storage;

  @override
  String get description => 'Remove a CLI resources';

  @override
  String get name => 'remove';

  CliRemoveGitCommand(this.storage);

  @override
  Future<void> run() async {
    argParser.addOption('name');
    var name = argResults['name'];
    await storage.removeCli(name);
  }
}
