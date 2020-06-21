import 'package:fast/config_storage.dart';
import 'package:test/test.dart';

void main() {
  test('should get a value', () async {
    var configStorage = ConfigStorage('test/resources/fast.json');

    await configStorage.setValue(ConfigKeys.commandsFilePath, '/test');

    var path = await configStorage.getValue(ConfigKeys.commandsFilePath);
    expect('/test', path);
  });
}
