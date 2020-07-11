import 'dart:io';

import 'package:fast/bash_manager.dart';
import 'package:test/test.dart';

void main() {
  test('shoud add a bash file', () async {
    var manager = BashFileManager('test/resources/bin');
    await manager.createExecutable('tenaz');

    var file = File('test/resources/bin/tenaz');
    expect(await file.exists(), true);
  });

  test('shoud remove a bash file', () async {});
}
