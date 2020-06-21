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

import 'package:path/path.dart';
import 'package:fast/core/action.dart';
import 'package:fast/yaml_manager.dart';
import '../core/process_extension.dart';
class RunCommandAction implements Action {
  final String yamlCommandPath;
  final Directory workingDirectory;
  final String commandName;

  RunCommandAction(
      this.workingDirectory, this.commandName, this.yamlCommandPath);

  @override
  Future<void> execute() async {
    var yamlCommand = YamlManager.readerYamlCommandsFile(
            normalize('${yamlCommandPath}/commands.yaml'))
        .firstWhere((yamlCommand) => yamlCommand.key == commandName);

    var splited = yamlCommand.command.split(' ');
    var name = splited[0];

    await FastProcessCLI().executeProcess(name,
        splited.getRange(1, splited.length).toList(), workingDirectory.path);
  }

  @override
  String get succesMessage => 'Run command.';
}
