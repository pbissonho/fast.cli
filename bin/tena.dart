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

import 'package:tena/commands/flutter/add_package.dart';
import 'package:tena/commands/flutter/clear_command.dart';
import 'package:tena/commands/flutter/config_command.dart';
import 'package:tena/commands/flutter/create_flutter_comand.dart';
import 'package:tena/commands/flutter/run_command.dart';
import 'package:tena/commands/flutter/setup_command.dart';
import 'package:tena/tena.dart';

void main(List<String> arguments) async {
  var tenazCLI = TenaCLI();
  await tenazCLI.setupCommandRunner();
  tenazCLI.configCommands([
    FlutterCreaterComand(),
    ClearCommand(),
    SetupComand(),
    RunComand(),
    AddPackageCommand(),
    ConfigCommand(),
    // CleateTemplate(logger)
  ]);
  tenazCLI.run(arguments);
}
