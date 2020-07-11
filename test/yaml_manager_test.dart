import 'package:fast/yaml_manager.dart';
import 'package:test/test.dart';

void main() {
  test('shoud read a cli file', () {
    var clIFile = YamlManager.readerCliFile('test/resources/clean/cli.yaml');

    expect(clIFile.name, 'clean');
  });
}
