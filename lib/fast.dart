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
import 'package:path/path.dart';
import 'package:fast/config_storage.dart';
import 'package:fast/core/exceptions.dart';
import 'package:fast/logger.dart';
import 'package:fast/yaml_manager.dart';
import 'commands/flutter/create_template.dart';

class FastCLI {
  final String _cliName = 'Fast CLI';
  final String _cliDescription = 'An incredible Dart CLI.';
  CommandRunner commandRunner;

  Future<void> setupCommandRunner(bool isConfigCommand) async {
    ConfigStorage fastStorage;
    commandRunner = CommandRunner(_cliName, _cliDescription);

    if (!isConfigCommand) {
      try {
        fastStorage = ConfigStorage();
        var templatesPath =
            await fastStorage.getValue(ConfigKeys.templatesPath);
        var templates = YamlManager.loadTemplates(templatesPath);

        templates.forEach((template) {
          addCommand(CreateTemplateCommand(
            template: template,
          ));
        });
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

  Future<void> run(List<String> arguments) async {
    try {
      await commandRunner.run(arguments);
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
