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
import 'package:tena/actions/create_structure.dart';
import 'package:tena/core/action.dart';
import 'package:tena/core/directory/directory.dart';
import 'package:tena/yaml_manager.dart';

import '../logger.dart';

class SetupAction implements Action {
  final String path;
  final bool force;
  final Project project;

  SetupAction(this.path, this.force, this.project);

  String get finishedDescription => 'Create the app and folder structure';

  @override
  Future<void> execute() async {
    var libPath = '$path/lib';
    var createStructAction =
        CreateProjectStructure(libPath, project.structure.mainFolder);

    if (await Directory(libPath).existsFiles()) {
      if (force) {
        await Directory(libPath).clear();
        await createStructAction.execute();
        logger.d('${runtimeType.toString()} finished. - $finishedDescription');
      } else {
        logger.e('''
${runtimeType.toString()} failed. - Lib folder has data. Use --force to allow the command to run.''');
      }
    } else {
      await Directory(libPath).clear();
      await createStructAction.execute();
      await logger
          .d('${runtimeType.toString()} finished. - $finishedDescription');
    }
  }

  @override
  String get actionName => 'Setup';
}
