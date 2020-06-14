import 'dart:io';

import 'package:tena/actions/run_command.dart';
import 'package:test/test.dart';

void main() {
  test('setup', () async {
    var setup = RunCommandAction(Directory.current, 'teste');

    await setup.execute();
  });
}
