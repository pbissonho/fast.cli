import 'package:fast/yaml_manager.dart';
import 'package:test/test.dart';

void main() {
  test('shoud load a scaffold file', () async{
    var scaffold = await YamlManager.loadScaffold('test/resources');
    expect(scaffold, isNotNull);
    expect(scaffold.name, 'sample');
  });
}
