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

import 'package:fast/core/action.dart';
import 'package:fast/core/fast_process.dart';
import 'package:fast/logger.dart';

class FlutterAppArgs {
  final String name;
  String description;
  String org;
  final bool useKotlin;
  final bool useSwift;
  final bool useAndroidX;

  FlutterAppArgs({
    this.useAndroidX = false,
    this.org = '',
    this.description = '',
    this.name,
    this.useKotlin = false,
    this.useSwift = false,
  }) {
    description ??= '';
    org ??= '';
  }
}

class CreateProjectAction implements Action {
  final String path;
  final FlutterAppArgs actionArgs;
  final FastProcess process;

  CreateProjectAction(this.path, this.actionArgs, this.process);

  @override
  Future<void> execute() async {
    final args = ['create', '--no-pub'];
    if (actionArgs.useKotlin) args.addAll(['-a', 'kotlin']);
    if (actionArgs.useSwift) args.addAll(['-i', 'swift']);
    if (actionArgs.useAndroidX) args.add('--androidx');

    args.addAll([
      '--project-name',
      actionArgs.name,
    ]);

    if (actionArgs.description.isEmpty) {
      args.addAll(
          ['--description', 'An application created with the FAST CLI.']);
    } else {
      args.addAll(['--description', actionArgs.description]);
    }

    args.add(path);
    logger.d('Creating the flutter application...');
    final processresult =
        await process.executeProcessShellPath('flutter', args, path);

    if (!processresult) {
      logger.d('An error has occurred while creating the flutter application.');
      exit(64);
    }
  }

  @override
  String get succesMessage => 'Create flutter app.';
}
