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

library tena;

import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:path/path.dart';
import 'package:tena/config_storage.dart';
import 'package:tena/core/exceptions.dart';
import 'package:tena/logger.dart';
import 'package:tena/yaml_manager.dart';
import 'commands/flutter/create_template.dart';

class TenazCLI {
  final String _cliName = 'Tenaz CLI';
  final String _cliDescription = 'An incredible Dart CLI.';
  CommandRunner _commandRunner;

  TenazCLI();

  Future<void> setupCommandRunner() async {
    TenazConfig tenazConfig;

    try {
      _commandRunner = CommandRunner(_cliName, _cliDescription);

      try {
        tenazConfig = await ConfigStorage().getConfig();
        var templates = YamlManager.loadTemplates(tenazConfig.templatesPath);

        templates.forEach((template) {
          _commandRunner.addCommand(CreateTemplateCommand(
              template: template,
              templateFolderPath: normalize(
                  '${tenazConfig.templatesPath}/${template.name}_template'),
              templateYamlPath: normalize(
                  '${tenazConfig.templatesPath}/${template.name}_template/template.yaml')));
        });
      } on NotFounfTenazConfigException catch (erro) {
        logger.e('Warning: ${erro.msg}');
      } catch (erro) {
        rethrow;
      }
    } on StorageException catch (erro) {
      logger.d(erro.msg);
      exit(64);
    } on TenazException catch (erro) {
      logger.d(erro.msg);
      exit(64);
    } catch (error) {
      if (error is! UsageException) rethrow;
      print(error);
      exit(64);
    }
  }

  void run(List<String> arguments) {
    try {
      _commandRunner.run(arguments);
    } on StorageException catch (erro) {
      logger.e(erro.msg);
    } catch (error) {
      if (error is! UsageException) rethrow;
      print(error);
      exit(64);
    }
  }

  void configCommands(List<Command> comands) {
    comands.forEach((command) {
      _commandRunner.addCommand(command);
    });
  }
}
