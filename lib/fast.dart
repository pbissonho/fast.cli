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
import 'commands/flutter/create_command.dart';
import 'commands/flutter/create_template.dart';
import 'commands/flutter/run_command.dart';
import 'commands/flutter/setup_command.dart';
import 'commands/flutter/snippets_command.dart';

class FastCLI {
  final PluginStorage pluginStorage;
  final CommandRunner commandRunner;

  FastCLI(this.commandRunner, this.pluginStorage);

  Future<void> setupCommandRunner(String pluginName) async {
    final plugin = await pluginStorage.readByName(pluginName);
    final pluginPath = plugin.path;

    try {
      final pathTemplates = '$pluginPath/templates';
      final templatesPathExists = await Directory(pathTemplates).exists();

      if (templatesPathExists) {
        final templates = YamlManager.loadTemplates(pathTemplates);

        templates?.forEach((template) {
          addCommand(CreateTemplateCommand(
            template: template,
          ));
        });
      }

      final plugin = await pluginStorage.readByName(pluginName);
      final scaffoldsPath = '${plugin.path}/scaffolds';

      addCommand(SnippetsCommand('${plugin.path}/templates', plugin));
      addCommand(RunCommand('${plugin.path}'));
      addCommand(CreateCommand(scaffoldsPath));
      addCommand(SetupCommand(scaffoldsPath));
    } catch (error) {
      if (error is UsageException || error is FastException) {
        logger.d(error.toString());
        exit(64);
      }
      logger.d('''An unknown error occurred. 
Please report creating a issue at https://github.com/pbissonho/fast.cli.''');
      rethrow;
    }
  }

  Future<void> run(List<String> arguments, bool loadPlugin) async {
    List<String> finalArguments;
    if (loadPlugin) {
      final lastIndex = arguments.length;
      finalArguments = arguments.getRange(2, lastIndex).toList();
    } else {
      finalArguments = arguments;
    }

    try {
      await commandRunner.run(finalArguments);
    } catch (error) {
      if (error is UsageException || error is FastException) {
        logger.d(error.toString());
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
