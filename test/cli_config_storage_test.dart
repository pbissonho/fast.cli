import 'dart:io';

import 'package:fast/config_storage.dart';
import 'package:test/test.dart';

void main() {
  test('shoud add a cli definition when not have file', () async {
    var file = File('test/resources/fast_clis.json');
    if (await file.exists()) {
      await file.delete();
    }

    var clIConfigStorage = CliConfigStorage('test/resources/fast_clis.json');
    await clIConfigStorage.addCli(CliModel(git: '', path: '/test', name: 'clean'));
    await clIConfigStorage.addCli(CliModel(git: '', path: '/test', name: 'tutuca'));

    var models = await clIConfigStorage.read();

    expect(models.models.length, 2);
  });

  test('shoud remove a cli definition', () async {
    var file = File('test/resources/fast_clis.json');
    if (await file.exists()) {
      await file.delete();
    }

    var clIConfigStorage = CliConfigStorage('test/resources/fast_clis.json');
    await clIConfigStorage.addCli(CliModel(git: '', path: '/test', name: 'clean'));

    await clIConfigStorage.removeCli('clean');

    var models = await clIConfigStorage.read();

    expect(models.models.length, 0);
  });
}
