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

import 'package:fast/actions/create_template.dart';
import 'package:fast/logger.dart';
import '../../yaml_manager.dart';
import '../command_base.dart';

class CreateTemplateCommand extends CommandBase {
  final Template template;

  @override
  String get description => '${template.description}[Template]';

  @override
  String get name => template.name;

  CreateTemplateCommand({this.template}) {
    template.args.forEach((arg) {
      argParser.addOption(arg);
    });
  }

  @override
  Future<void> run() async {
    final argsMap = <String, String>{};

    template.args.forEach((arg) {
      final argResult = argResults[arg];

      if (argResult != null) {
        argsMap[arg] = argResult;
      }
    });

    var createTamplateAction = CreateTemplateAction(template, argsMap);
    await createTamplateAction.execute();

    logger.d('Template created successfully.');
    logger.d('Created in ${template.to}.');
  }
}
