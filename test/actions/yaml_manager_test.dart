import 'package:fast/yaml_manager.dart';
import 'package:test/test.dart';

void main() {
  test('should load a scaffold file', () async {
    final scaffold = await YamlManager.loadScaffold('test/resources');
    expect(scaffold, isNotNull);
    expect(scaffold.name, 'sample');
  });
}
