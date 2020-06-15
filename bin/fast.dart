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

import 'package:fast/commands/flutter/add_package.dart';
import 'package:fast/commands/flutter/clear_command.dart';
import 'package:fast/commands/flutter/config_command.dart';
import 'package:fast/commands/flutter/create_flutter_comand.dart';
import 'package:fast/commands/flutter/run_command.dart';
import 'package:fast/commands/flutter/setup_command.dart';
import 'package:fast/fast.dart';

void main(List<String> arguments) async {
  var fastzCLI = fastCLI();
  await fastzCLI.setupCommandRunner();
  fastzCLI.configCommands([
    FlutterCreaterComand(),
    ClearCommand(),
    SetupComand(),
    RunComand(),
    InstallPackageCommand(),
    ConfigCommand(),
    // CleateTemplate(logger)
  ]);
  fastzCLI.run(arguments);
}
