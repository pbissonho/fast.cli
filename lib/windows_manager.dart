import 'dart:io';

import 'bash_manager.dart';
import 'core/directory.dart';

class WindowsManager extends BashFileManager {
  @override
  Future<void> removeExecutable(String name) async {
    final file = File('$filePath/$name.bat');
    await file.delete();
  }

  @override
  Future<void> createExecutable(String name) async {
    final directory = Directory(filePath);
    final file = File('$filePath/$name.bat');
    if (!await directory.exists()) {
      await directory.createRecursive();
    }
    await file.create();
    await file.writeAsString(createBashFileData(name));
  }

  @override
  String createBashFileData(String name) {
    return '''
@echo off
fast load_plugin $name %1 %2 %3 %4 %5 %6 %7 %8 %9
    ''';
  }
}
