import 'package:fast/yaml_manager.dart';
import 'package:test/test.dart';

void main() {
  test('should read a plugin file', () {
    final yamlPlugin =
        YamlManager.readerYamlPluginFile('test/resources/clean/plugin.yaml');

    expect(yamlPlugin.name, 'clean');
  });
}
