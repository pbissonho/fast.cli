import 'package:tena/config_storage.dart';
import 'package:test/test.dart';

void main() {
  test('Cache path test', () async {
    var configStorage = ConfigStorage();

    await configStorage.setConfig(TenaConfig(
        templatesPath: '/home/pedro/Documentos/tenaz_resources/templates/'));

    var getConfig = await configStorage.getConfig();

    print(getConfig);
  });
}
