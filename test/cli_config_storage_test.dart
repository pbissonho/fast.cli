import 'dart:io';

import 'package:fast/config_storage.dart';
import 'package:test/test.dart';

void main() {
  test('shoud add a plugin definition when not have file', () async {
    var file = File('test/resources/plugins.json');
    if (await file.exists()) {
      await file.delete();
    }

    var pluginStorage = PluginStorage('test/resources/plugins.json');
    await pluginStorage.add(Plugin(git: '', path: '/test', name: 'clean'));
    await pluginStorage.add(Plugin(git: '', path: '/test', name: 'tutuca'));

    var plugins = await pluginStorage.read();

    expect(plugins.length, 2);
  });

  test('shoud remove a plugin definition', () async {
    var file = File('test/resources/plugins.json');
    if (await file.exists()) {
      await file.delete();
    }

    var pluginStorage = PluginStorage('test/resources/plugins.json');
    await pluginStorage.add(Plugin(git: '', path: '/test', name: 'clean'));

    await pluginStorage.remove('clean');

    var plugins = await pluginStorage.read();

    expect(plugins.length, 0);
  });
}
