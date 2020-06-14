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
import 'package:pubspec_yaml/pubspec_yaml.dart';
import 'package:tena/core/action.dart';

class SetupYaml implements Action {
  final String pubspecPath;
  final String projectPath;

  SetupYaml(this.pubspecPath, this.projectPath);

  String get finishedDescription => 'Setup pubspec.yaml';

  @override
  Future<void> execute() async {
    var pubspecFile = File(pubspecPath);

    final projectYaml = File('$projectPath').readAsStringSync().toPubspecYaml();

    final pubsYaml = pubspecFile.readAsStringSync().toPubspecYaml();

    var finalYaml = pubsYaml.copyWith(dependencies: [
      ...projectYaml.dependencies,
      ...pubsYaml.dependencies
    ], devDependencies: [
      ...projectYaml.devDependencies,
      ...pubsYaml.devDependencies
    ]);

    var yamlData = finalYaml.toYamlString();

    await pubspecFile.writeAsString(yamlData);
  }

  @override
  String get actionName => 'Setup pubspec.yaml';
}
