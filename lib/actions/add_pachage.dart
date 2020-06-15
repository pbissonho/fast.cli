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
import 'package:plain_optional/plain_optional.dart';
import 'package:pubspec_yaml/pubspec_yaml.dart';
import 'package:fast/core/action.dart';
import 'package:fast/services/packages_service.dart';

class AddPackage implements Action {
  final String name;
  final String version;
  final String yamlPath;

  AddPackage(this.name, this.yamlPath, [this.version = '']);

  @override
  Future<void> execute() async {
    var pubspecFile = File(yamlPath);
    Optional optionalVersion;

    final pubsYaml = pubspecFile.readAsStringSync().toPubspecYaml();

    if (version.isEmpty) {
      var package = await PackagesService().fetchPackage(name);
      optionalVersion = Optional<String>('^${package.latest.version}');
    } else {
      optionalVersion = Optional<String>(version);
    }

    var finalYaml = pubsYaml.copyWith(dependencies: [
      ...pubsYaml.dependencies,
      PackageDependencySpec.hosted(
          HostedPackageDependencySpec(package: name, version: optionalVersion))
    ]);

    var yamlData = finalYaml.toYamlString();

    await pubspecFile.writeAsString(yamlData);
  }

  @override
  String get actionName => 'Add a package to project.';
}
