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

library fast;

import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:fast/config_storage.dart';
import 'package:fast/core/exceptions.dart';
import 'package:fast/logger.dart';
import 'package:fast/yaml_manager.dart';
import 'commands/flutter/create_flutter_comand.dart';
import 'commands/flutter/create_template.dart';
import 'commands/flutter/run_command.dart';
import 'commands/flutter/setup_command.dart';
import 'commands/flutter/snippets_command.dart';

class FastCLI {
  final ConfigStorage _configStorage;
  final CliConfigStorage cliConfigStorage;
  final CommandRunner commandRunner;

  FastCLI(this._configStorage, this.commandRunner, this.cliConfigStorage);

  Future<void> setupCommandRunner(bool isConfigCommand) async {
    if (!isConfigCommand) {
      try {
        var templatesPath =
            await _configStorage.getValue(ConfigKeys.templatesPath);
        var templates = YamlManager.loadTemplates(templatesPath);

        templates.forEach((template) {
          addCommand(CreateTemplateCommand(
            template: template,
          ));
        });

        var commandsFilePath =
            await _configStorage.getValue(ConfigKeys.commandsFilePath);
        var scaffoldsPath =
            await _configStorage.getValue(ConfigKeys.scaffoldsPath);

        addCommand(SnippetsCommand(templatesPath));
        addCommand(RunComand(commandsFilePath));
        addCommand(FlutterCreaterComand(scaffoldsPath));
        addCommand(SetupComand(scaffoldsPath));
      } catch (error) {
        if (error is UsageException) {
          logger.d(error.toString());
          exit(64);
        }

        if (error is FastException) {
          logger.d(error);
          exit(64);
        }

        logger.d('''An unknown error occurred. 
Please report creating a issue at https://github.com/pbissonho/fast.cli.''');
        rethrow;
      }
    }
  }

  Future<void> setupCommandRunnerCli(
      bool isConfigCommand, String cliName) async {
    var cliModel = await cliConfigStorage.readByName(cliName);
    var cliPath = cliModel.path;
    if (!isConfigCommand) {
      try {
        var templates = YamlManager.loadTemplates('$cliPath/templates');

        templates.forEach((template) {
          addCommand(CreateTemplateCommand(
            template: template,
          ));
        });

        var cliModel = await cliConfigStorage.readByName(cliName);
        var templatesPath = '${cliModel.path}/templates';
        var scaffolsPath = '${cliModel.path}/scaffolds';
        addCommand(SnippetsCommand(templatesPath));
        addCommand(RunComand('${cliModel.path}'));
        addCommand(FlutterCreaterComand(scaffolsPath));
        addCommand(SetupComand(scaffolsPath));
        
      } catch (error) {
        if (error is UsageException) {
          logger.d(error.toString());
          exit(64);
        }

        if (error is FastException) {
          logger.d(error);
          exit(64);
        }

        logger.d('''An unknown error occurred. 
Please report creating a issue at https://github.com/pbissonho/fast.cli.''');
        rethrow;
      }
    }
  }

  Future<void> run(List<String> arguments, bool isCli) async {
    List<String> finalArguments;
    if (isCli) {
      var lastIndex = arguments.length;
      finalArguments = arguments.getRange(2, lastIndex).toList();
    } else {
      finalArguments = arguments;
    }

    try {
      await commandRunner.run(finalArguments);
    } catch (error) {
      if (error is UsageException) {
        logger.d(error.toString());
        exit(64);
      }

      if (error is FastException) {
        logger.d(error);
        exit(64);
      }

      logger.d('''An unknown error occurred. 
Please report creating a issue at https://github.com/pbissonho/fast.cli.''');
      rethrow;
    }
  }

  void addCommands(List<Command> comands) {
    comands.forEach((command) {
      commandRunner.addCommand(command);
    });
  }

  void addCommand(Command comand) {
    commandRunner.addCommand(comand);
  }
}
