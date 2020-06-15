import 'dart:io';
import 'package:fast/actions/setup_yaml.dart';
import 'package:fast/yaml_manager.dart';
import 'package:test/test.dart';

void main() {
  /*
  test('Yaml test', () async {
    await Directory(absolutPath + '/src').createRecursive();

    var clearAction = ClearProjectStructure('$absolutPath/src/');
    var action = CreateProjectStructure(
        '$absolutPath/src/', yamlManager.structure.mainFolder);
    var builderAction = ActionBuilder();
    builderAction..add(clearAction)..add(action);

    await builderAction.execute();
  });*/

  test('YamlManager test', () {
    var manage = YamlManager();
    print(manage);
  });

  Future<void> createFolderFile(YamlFile fileSource) async {
    var file = await File('${fileSource.name}${fileSource.extension}');
    await file.create();
    await file.writeAsString(fileSource.content);
  }

  test('xxx test', () async {
    await createFolderFile(YamlFile('tuka', extension: '.dart', content: '''
      fsdf
      fsdfsd
      fsdfsd
      sdfsd
    '''));
  });

  test('setup YAML', () async {
    var setupYaml = SetupYaml(
        'test/resources/_pubspec.yaml', 'test/resources/scaffold.yaml');

    await setupYaml.execute();
  });
}
