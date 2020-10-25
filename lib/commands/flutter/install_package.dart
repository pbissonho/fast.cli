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

import 'package:fast/actions/add_dependencies.dart';
import 'package:fast/actions/add_pachage.dart';
import '../../config_storage.dart';
import '../../logger.dart';
import '../command_base.dart';

class InstallPackageCommand extends CommandBase {
  final Plugin plugin;

  @override
  String get description => 'Adds a package to the dependencies.';

  @override
  String get name => 'install';

  InstallPackageCommand(this.plugin) {
    argParser.addOption('version', abbr: 'v', help: 'Package version.');
    argParser.addFlag('dev', abbr: 'd', help: 'Add to dev_dependencies');
    addSubcommand(InstallSetPackageCommand(plugin));
  }

  @override
  Future<void> run() async {
    var packageName = argResults.rest[0];
    var packageVersion = argResults['version'];
    var isDev = argResults['dev'];

    var addPackageAction =
        AddPackage(packageName, 'pubspec.yaml', isDev, packageVersion);
    await addPackageAction.execute();
    await logger.d(addPackageAction.succesMessage);
  }
}

class InstallSetPackageCommand extends CommandBase {
  final Plugin plugin;

  InstallSetPackageCommand(this.plugin);

  @override
  String get description => 'Adds a set of package to the dependencies.';

  @override
  String get name => 'set';

  @override
  Future<void> run() async {
    var setName = argResults.rest[0];

    var addSet = AddDependenciesAction(
        'pubspec.yaml', '${plugin.path}/sets/$setName.yaml');
    await addSet.execute();
    await logger.d(addSet.succesMessage);
  }
}
