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

import 'package:fast/logger.dart';
import 'package:flunt_dart/flunt_dart.dart';
import 'package:fast/actions/run_command.dart';

import '../command_base.dart';

class RunCommand extends CommandBase {
  RunCommand(this.commandsFilePath);

  @override
  String get description => 'Run a command.';
  @override
  String get name => 'run';

  String get finishedDescription => 'Run a command.';

  final String commandsFilePath;

  @override
  Future<void> run() async {
    validate(Contract('', ''));
    final name = argResults.rest[0];
    final workingDirectory = Directory.current;
    logger.d('Running the $name command...');
    await RunCommandAction(workingDirectory, name, commandsFilePath).execute();
    logger.d('Command successfully executed.');
  }
}
