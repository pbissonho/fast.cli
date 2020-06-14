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

import 'package:flunt_dart/flunt_dart.dart';
import 'package:path/path.dart';
import 'package:tena/yaml_manager.dart';
import '../../config_storage.dart';
import '../../logger.dart';
import 'package:tena/actions/clear_structure.dart';
import 'package:tena/actions/create_structure.dart';
import 'package:tena/actions/creater_flutter_action.dart';
import 'package:tena/actions/setup_yaml.dart';
import 'package:tena/actions/show_folder_structure.dart';
import 'package:tena/core/tenaz_process.dart';
import '../command_base.dart';

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

class FlutterCreaterComand extends CommandBase {
  @override
  String get description => 'Create the app and folder structure';

  @override
  String get name => 'create';

  String get finishedDescription => 'Create the app and folder structure';

  FlutterCreaterComand() {
    argParser.addOption('name', abbr: 'n', help: 'Project name.');
    argParser.addOption('scaffold', abbr: 's', help: 'Scaffold template name.');
    argParser.addOption('description',
        abbr: 'd', help: 'Project descritiopn.');
    argParser.addFlag('kotlin', abbr: 'a', help: 'User kotlin.');
    argParser.addFlag('swift', abbr: 'i', help: 'User Swift.');
    argParser.addFlag('androidx', abbr: 'x', help: 'Use AndroidX.');
  }

  @override
  Future<void> run() async {
    var appName = argResults['name'];
    var scaffoldName = argResults['scaffold'];
    var description = argResults['description'];
    var useKotlin = argResults.wasParsed('kotlin');
    var useSwift = argResults.wasParsed('swift');
    var useAndroidX = argResults.wasParsed('androidx');

    var flutterScaffoldArgs = FlutterAppArgs(
        useAndroidX: useAndroidX,
        name: appName,
        description: description,
        useKotlin: useKotlin,
        useSwift: useSwift);

    var ScaffoldsPath =
        await ConfigStorage().getConfigByKeyOrBlank(ConfigKeys.scaffoldsPath);
    var Scaffold =
        YamlManager.loadScaffold(normalize('$ScaffoldsPath/$scaffoldName'));

    validate(
        Contract<FlutterAppArgs>(flutterScaffoldArgs, 'FlutterScaffoldArgs'));

    // Create Flutter App
    var createFlutter =
        CreaterFlutterAction(appName, flutterScaffoldArgs, TenazProcessCli());
    await createFlutter.execute();
    logger.d('Action: ${createFlutter.actionName}');

    // Clear Flutter lib and test folders.
    var clearLibFolder = ClearScaffoldStructure('$appName/lib');
    var clearTestFolder = ClearScaffoldStructure('$appName/test');
    await clearLibFolder.execute();
    await clearTestFolder.execute();
    logger.d('Action: ${clearLibFolder.actionName}');
    logger.d('Action: ${clearTestFolder.actionName}');

    // Scaffold Structure
    var createScaffoldStructure =
        CreateScaffoldStructure('$appName/lib', Scaffold.structure.mainFolder);

    var showScaffoldStructure =
        ShowFolderStructure(Scaffold.structure.mainFolder);

    await createScaffoldStructure.execute();
    logger.d('Action: ${createScaffoldStructure.actionName}');
    await showScaffoldStructure.execute();
    logger.d('Action: ${showScaffoldStructure.actionName}');

    // Test Structure
    var createTestStructure = CreateFolderStructure(
        '$appName/test', Scaffold.testStructure.mainFolder);
    var showTestStructure =
        ShowFolderStructure(Scaffold.testStructure.mainFolder);
    await createTestStructure.execute();
    logger.d('Action: ${createTestStructure.actionName}');
    await showTestStructure.execute();
    logger.d('Action: ${showTestStructure.actionName}');

    // Setup YAML
    var setupYaml = SetupYaml('$appName/pubspec.yaml',
        normalize('$ScaffoldsPath/$scaffoldName/scaffold.yaml'));
    await setupYaml.execute();
    logger.d('Action: ${setupYaml.actionName}');

    logger.d('${runtimeType.toString()} finished. - $finishedDescription');
  }
}

