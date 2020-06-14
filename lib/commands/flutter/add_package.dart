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

import 'package:tena/actions/add_pachage.dart';
import '../../logger.dart';
import '../command_base.dart';

class AddPackageCommand extends CommandBase {
  @override
  String get description => 'Adds a package to the dependencies.';

  @override
  String get name => 'add';

  String get finishedDescription => 'Adds a package to the dependencies.';

  AddPackageCommand() {
    argParser.addOption('name', abbr: 'n', help: 'Package name.');
    argParser.addOption('version', abbr: 'v', help: 'Package version.');
  }

  @override
  Future<void> run() async {
    var packageName = argResults['name'];
    // var packageVersion = argResults['version'];

    var addPackageAction = AddPackage(packageName, 'pubspec.yaml', '');
    await addPackageAction.execute();

    logger.d('${runtimeType.toString()} finished. - $finishedDescription');
  }
}
