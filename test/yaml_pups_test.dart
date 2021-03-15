import 'dart:io';
import 'package:pubspec_yaml/pubspec_yaml.dart';
import 'package:test/test.dart';

void main() {
  test('should read yaml file', () {
    var pubspecFile = File('flutter.yaml');

    final projectYaml =
        File('lib/project.yaml').readAsStringSync().toPubspecYaml();

    final pubsYaml = pubspecFile.readAsStringSync().toPubspecYaml();

    var finalYaml = pubsYaml.copyWith(dependencies: [
      ...projectYaml.dependencies,
      ...pubsYaml.dependencies
    ], devDependencies: [
      ...projectYaml.devDependencies,
      ...pubsYaml.devDependencies
    ]);

    var yamlData = finalYaml.toYamlString();

    pubspecFile.writeAsString(yamlData);
  }, skip: true);
}
