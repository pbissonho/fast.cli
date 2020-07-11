import 'dart:io';

import 'core/home_path.dart';
import 'core/directory/directory.dart';

// Manages the creation of bash executables.
class BashFileManager {
  BashFileManager([String filePath]) {
    if (filePath != null) _filePath = filePath;
  }

  String _filePath = '${homePath()}/bin';

  // Create a executable named 'name'.
  Future<void> createExecutable(String name) async {
    var directory = Directory(_filePath);
    var file = File('$_filePath/$name');
    if (!await directory.exists()) {
      await directory.createRecursive();
    }

    await file.create();
    await file.writeAsString(_createBashFileData(name));
    var path = '${homePath()}/bin/';
    var result = await configFileAsExecutable('chmod', ['+x', '$name'], path);
  }

  @override
  Future<bool> configFileAsExecutable(
      String name, List<String> args, String path) async {
    var process = await Process.start(name, args,
            runInShell: true, workingDirectory: path)
        .then((result) async {
      await stdout.addStream(result.stdout);
      await stderr.addStream(result.stderr);
      return result;
    });
    var result = await process.exitCode;

    if (result == 0) return true;
    return false;
  }

  // Return the bash file to execute a CLI.
  String _createBashFileData(String name) {
    return ''' 
#!/bin/bash
fast cli $name \$1 \$2 \$3 \$4 \$5 \$6 \$7 \$8 \$9
''';
  }

  Future<void> remove(String name) async {
    var file = File('$_filePath/$name');
    await file.delete();
  }
}
