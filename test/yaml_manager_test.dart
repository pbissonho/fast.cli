import 'package:fast/yaml_manager.dart';
import 'package:test/test.dart';

void main() {
  test('shoud read a cli file', () {
    var clIFile =
        YamlManager.readerYamlPluginFile('test/resources/clean/plugin.yaml');

    expect(clIFile.name, 'clean');
  });

  test('shoud reader yaml scaffold file', () async {
    var scaffold = await ScaffoldReader.readerYamlScaffoldFile(
        'clean', '/home/pedro/Documentos/fast_plugins/clean/');

    expect(scaffold.name, 'clean');
  });
}
