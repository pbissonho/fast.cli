import 'dart:io';

import 'package:fast/config_storage.dart';
import 'package:test/test.dart';

void main() {
  test('should add a plugin definition when not have file', () async {
    final file = File('test/resources/plugins.json');
    if (await file.exists()) {
      await file.delete();
    }

    final pluginStorage = PluginStorage('test/resources/plugins.json');
    await pluginStorage.add(Plugin(git: '', path: '/test', name: 'clean'));
    await pluginStorage.add(Plugin(git: '', path: '/test', name: 'tutuca'));

    final plugins = await pluginStorage.read();

    expect(plugins.length, 2);
  });

  test('should remove a plugin definition', () async {
    final file = File('test/resources/plugins.json');
    if (await file.exists()) {
      await file.delete();
    }

    final pluginStorage = PluginStorage('test/resources/plugins.json');
    await pluginStorage.add(Plugin(git: '', path: '/test', name: 'clean'));

    await pluginStorage.remove('clean');

    final plugins = await pluginStorage.read();

    expect(plugins.length, 0);
  });
}
