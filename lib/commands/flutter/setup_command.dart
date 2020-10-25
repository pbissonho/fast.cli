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

import 'package:fast/actions/builder_action.dart';
import 'package:fast/actions/create_structure.dart';
import 'package:flunt_dart/flunt_dart.dart';
import 'package:fast/actions/show_folder_structure.dart';
import '../../config_storage.dart';
import '../../logger.dart';
import '../../yaml_manager.dart';
import '../command_base.dart';

class SetupComand extends CommandBase {
  final Plugin plugin;

  @override
  String get description =>
      'Create the scaffold within a flutter project already created. Keep existing files.';

  @override
  String get name => 'setup';

  SetupComand(this.plugin) {
    argParser.addFlag('force',
        abbr: 'f', help: 'Create even with data in the lib folder.');
    argParser.addOption('scaffold', abbr: 'p', help: 'scaffold template name.');
  }

  @override
  Future<void> run() async {
    validate(Contract('', ''));
    var scaffoldName = argResults['scaffold'];
    var scaffold = await ScaffoldReader(plugin).loadScaffold(scaffoldName);

    var actionBuilder = ActionBuilder([
      CreateFolderStructure('lib', scaffold.structure.mainFolder,
          'Created /lib folder structure.'),
      ShowFolderStructure(scaffold.structure.mainFolder),
      CreateFolderStructure('test', scaffold.testStructure.mainFolder,
          'Created /test folder structure.'),
      ShowFolderStructure(scaffold.testStructure.mainFolder),
      //SetupYaml('pubspec.yaml',
      //  normalize('$scaffoldsPath/$scaffoldName/scaffold.yaml'))
    ]);

    await actionBuilder.execute();

    logger.d('All done. Application configured.');
  }
}

class StructComand extends CommandBase {
  final Plugin plugin;

  @override
  String get description => 'Create a folder structure.';

  @override
  String get name => 'struct';

  StructComand(this.plugin) {
    argParser.addOption('name', abbr: 'n', help: 'Folder structure name.');
  }

  @override
  Future<void> run() async {
    validate(Contract('', ''));
    var structName = argResults['name'];
    var to = argResults.rest[0];

    var structure = await StructureReader(plugin).reader(structName, to);

    var actionBuilder = ActionBuilder([
      CreateFolderStructure(
          to, structure.mainFolder, 'Created $structName structure.'),
      ShowFolderStructure(structure.mainFolder),
    ]);

    await actionBuilder.execute();

    logger.d('All done. Structure configured.');
  }
}
