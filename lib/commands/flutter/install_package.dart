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

import 'package:fast/actions/add_pachage.dart';
import '../../logger.dart';
import '../command_base.dart';

class InstallPackageCommand extends CommandBase {
  @override
  String get description => 'Adds a package to the dependencies.';

  @override
  String get name => 'install';

  InstallPackageCommand() {
    argParser.addOption('version', abbr: 'v', help: 'Package version.');
    argParser.addFlag('dev', abbr: 'd', help: 'Add to dev_dependencies');
  }

  @override
  Future<void> run() async {
    final packageName = argResults.rest[0];
    final packageVersion = argResults['version'];
    final isDev = argResults['dev'];

    final addPackageAction =
        AddPackage(packageName, 'pubspec.yaml', isDev, packageVersion);
    await addPackageAction.execute();
    await logger.d(addPackageAction.succesMessage);
  }
}
