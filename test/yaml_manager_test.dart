import 'package:fast/yaml_manager.dart';
import 'package:test/test.dart';

void main() {
  test('shoud read a cli file', () {
    var clIFile =
        YamlManager.readerYamlPluginFile('test/resources/clean/plugin.yaml');

    expect(clIFile.name, 'clean');
  });
}
