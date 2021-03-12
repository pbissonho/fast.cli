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
import 'package:fast/core/home_path.dart';
import 'package:fast/logger.dart';
import 'package:flunt_dart/flunt_dart.dart';
import '../../config_storage.dart';
import '../../core/exceptions.dart';
import '../../snippet_manager.dart';
import '../../yaml_manager.dart';
import '../command_base.dart';

class SnippetsCommand extends CommandBase {
  final templatesPath;
  final Plugin plugin;
  @override
  String get description => 'Create Visual Studio Code Snippets';

  @override
  String get name => 'snippets';

  SnippetsCommand(this.templatesPath, this.plugin);

  @override
  Future<void> run() async {
    validate(Contract('', ''));

    final templates = await YamlManager.loadTemplates(templatesPath);

    if (templates.isEmpty) {
      logger.d('The plugin not have any template');
      return;
    }

    String globalSnippetsPath;
    if (Platform.isLinux || Platform.isMacOS) {
      globalSnippetsPath =
          '${homePath()}/.config/Code/User/snippets/${plugin.name}_created.code-snippets';
    } else if (Platform.isWindows) {
      globalSnippetsPath =
          '${homePath()}/AppData/Roaming/Code/User/snippets/${plugin.name}_created.code-snippets';
    } else {
      throw FastException('Platform not support VS Code Generators');
    }
    await SnippetGenerator(
            templates.where((template) => template.hasSnippets()).toList(),
            templatesPath,
            globalSnippetsPath)
        .generateSnippedFile();

    logger.d('Snippets for ${plugin.name} plugin successfully created.');
  }
}
