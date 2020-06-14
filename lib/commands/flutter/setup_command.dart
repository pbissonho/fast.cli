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

import 'package:flunt_dart/flunt_dart.dart';
import 'package:tena/actions/setup_action.dart';
import 'package:tena/actions/show_folder_structure.dart';
import '../../config_storage.dart';
import '../../yaml_manager.dart';
import '../command_base.dart';

class SetupComand extends CommandBase {
  @override
  String get description => 'Create the app and folder structure';

  @override
  String get name => 'setup';

  String get finishedDescription => 'Create the app and folder structure';

  SetupComand() {
    argParser.addFlag('force',
        abbr: 'f', help: 'Create even with data in the lib folder.');
    argParser.addOption('scaffold', abbr: 'p', help: 'scaffold template name.');
  }

  @override
  Future<void> run() async {
    validate(Contract('', ''));
    var force = argResults.wasParsed('force');
    var scaffoldName = argResults['scaffold'];

    var scaffoldsPath =
        ConfigStorage().getConfigByKeyOrBlank(ConfigKeys.scaffoldsPath);
    var scaffold = YamlManager.loadScaffold('$scaffoldsPath/$scaffoldName');

    await SetupAction(Directory.current.path, force, scaffold).execute();
    await ShowFolderStructure(scaffold.structure.mainFolder).execute();
  }
}
