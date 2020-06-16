import 'package:fast/config_storage.dart';
import 'package:test/test.dart';

void main() {
  test('Cache path test', () async {
    var configStorage = ConfigStorage();

    await configStorage.setConfig(FastConfig(
        templatesPath: '/home/pedro/Documentos/fastz_resources/templates/'));

    var getConfig = await configStorage.getConfig();

    print(getConfig);
  }, skip: true);
}
