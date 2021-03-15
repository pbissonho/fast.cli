import 'dart:io';
import 'package:fast/actions/plugin_add_git_action.dart';
import 'package:fast/bash_manager.dart';
import 'package:fast/config_storage.dart';
import 'package:test/test.dart';

void main() {
  test('should add a bash file', () async {
    final manager = BashFileManager(filePath: 'test/resources/bin');
    await manager.createExecutable('tenaz');

    final file = File('test/resources/bin/tenaz');
    expect(await file.exists(), true);
  });

  test(
    'should add a bash file with git repo',
    () async {
      final action = PluginAddGitAction(
          PluginStorage(),
          BashFileManager(
              filePath: 'test/resources/bin',
              gitCachePath: 'test/resources/cache'));

      action.setUrl('https://github.com/pbissonho/mvc_plugin.git');

      await action.execute();

      final file = File('test/resources/bin/mvc');
      expect(await file.exists(), true);
    },
  );
}
