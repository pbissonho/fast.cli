import 'package:fast/config_storage.dart';
import 'package:fast/yaml_manager.dart';
import 'package:test/test.dart';

void main() {
  test('shoud load a scaffold file', () async {
    var scaffold = await ScaffoldReader(
            Plugin(name: 'clean', path: 'test/resources/clean'))
        .loadScaffold('mobx');
    expect(scaffold, isNotNull);
    expect(scaffold.name, 'mobx');
  });
}
