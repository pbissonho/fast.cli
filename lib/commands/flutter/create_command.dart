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

import 'package:fast/actions/action_builder.dart';
import 'package:fast/actions/copy_scaffold_files.dart';
import 'package:fast/actions/create_project_action.dart';
import 'package:fast/core/fast_process.dart';
import 'package:flunt_dart/flunt_dart.dart';
import 'package:path/path.dart';
import 'package:fast/yaml_manager.dart';
import '../../logger.dart';
import 'package:fast/actions/clear_structure.dart';
import 'package:fast/actions/create_structure.dart';
import 'package:fast/actions/setup_yaml.dart';
import 'package:fast/actions/show_folder_structure.dart';
import '../command_base.dart';

class CreateCommand extends CommandBase {
  final String scaffoldsPath;

  @override
  String get description => 'Create the app and folder structure';

  @override
  String get name => 'create';

  String get finishedDescription => 'Create the app and folder structure';

  CreateCommand(this.scaffoldsPath) {
    argParser.addOption('name', abbr: 'n', help: 'Project name.');
    argParser.addOption('scaffold', abbr: 's', help: 'Scaffold template name.');
    argParser.addOption('description', abbr: 'd', help: 'Project descritiopn.');
    argParser.addFlag('kotlin', abbr: 'a', help: 'User kotlin.');
    argParser.addFlag('swift', abbr: 'i', help: 'User Swift.');
    argParser.addFlag('androidx', abbr: 'x', help: 'Use AndroidX.');
  }

  @override
  Future<void> run() async {
    final appName = argResults['name'];
    final scaffoldName = argResults['scaffold'];
    final description = argResults['description'];
    final useKotlin = argResults.wasParsed('kotlin');
    final useSwift = argResults.wasParsed('swift');
    final useAndroidX = argResults.wasParsed('androidx');

    final flutterScaffoldArgs = FlutterAppArgs(
        useAndroidX: useAndroidX,
        name: appName,
        description: description,
        useKotlin: useKotlin,
        useSwift: useSwift);

    final scaffold =
        YamlManager.loadScaffold(normalize('$scaffoldsPath/$scaffoldName'));

    validate(
        Contract<FlutterAppArgs>(flutterScaffoldArgs, 'FlutterScaffoldArgs'));

    await CreateProjectAction(appName, flutterScaffoldArgs, FastProcessCLI())
        .execute();

    final actionBuilder = ActionBuilder([
      ClearScaffoldStructure('$appName/lib',
          excludedFiles: ['$appName/lib/main.dart']),
      ClearScaffoldStructure('$appName/test',
          excludedFiles: ['$appName/test/widget_test.dart']),
      CreateFolderStructure('$appName/lib', scaffold.structure.mainFolder,
          'Created /lib folder structure.'),
      ShowFolderStructure(scaffold.structure.mainFolder),
      CreateFolderStructure('$appName/test', scaffold.testStructure.mainFolder,
          'Created /test folder structure.'),
      ShowFolderStructure(scaffold.testStructure.mainFolder),
      SetupYaml('$appName/pubspec.yaml',
          normalize('$scaffoldsPath/$scaffoldName/scaffold.yaml')),
      CopyScaffoldFiles('$scaffoldsPath/$scaffoldName/files', appName,
          scaffold.copyFiles ?? false),
    ]);

    await actionBuilder.execute();

    logger.d('All done. Application created and configured.');
  }
}
