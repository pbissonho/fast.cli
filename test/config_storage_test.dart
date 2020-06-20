import 'package:fast/config_storage.dart';
import 'package:test/test.dart';

void main() {
  test('should set a config', () async {
    var configStorage = ConfigStorage('test/resources/fast.json');

    await configStorage.setConfig(FastConfig(
        templatesPath: '/home',
        scaffoldsPath: '/test',
        commandsFilePath: '/test'));

    var getConfig = await configStorage.getConfig();

    expect(getConfig.templatesPath, '/home');
    expect(getConfig.scaffoldsPath, '/test');
    expect(getConfig.commandsFilePath, '/test');
  });

  test('should set a value', () async {
    var configStorage = ConfigStorage('test/resources/fast.json');
    await configStorage.setConfig(FastConfig(
        templatesPath: '/home',
        scaffoldsPath: '/test',
        commandsFilePath: '/test'));

    await configStorage.setValue(ConfigKeys.commandsFilePath, '/test/test2');

    var getConfig = await configStorage.getConfig();

    expect(getConfig.templatesPath, '/home');
    expect(getConfig.scaffoldsPath, '/test');
    expect(getConfig.commandsFilePath, '/test/test2');
  });

  test('should get a value', () async {
    var configStorage = ConfigStorage('test/resources/fast.json');

    await configStorage.setConfig(FastConfig(
        templatesPath: '/home',
        scaffoldsPath: '/test',
        commandsFilePath: '/test1'));

    var path =
        await configStorage.getValueByKeyOrBlank(ConfigKeys.commandsFilePath);
    var getConfig = await configStorage.getConfig();
    expect(getConfig.commandsFilePath, path);
    expect(getConfig.commandsFilePath, '/test1');
  });
}
