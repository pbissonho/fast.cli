import 'dart:io';
import 'package:fast/actions/plugin_add_git_action.dart';
import 'package:fast/bash_manager.dart';
import 'package:fast/config_storage.dart';
import 'package:test/test.dart';

void main() {
  test('shoud add a bash file', () async {
    var manager = BashFileManager(filePath: 'test/resources/bin');
    await manager.createExecutable('tenaz');

    var file = File('test/resources/bin/tenaz');
    expect(await file.exists(), true);
  });

  test('shoud add a bash file with git repo', () async {
    var action = PluginAddGitAction(PluginStorage(), BashFileManager());

    action.setUrl('https://github.com/pbissonho/mvc_git_test.git');
    await action.execute();
  }, timeout: Timeout(Duration(minutes: 10)));
}
