import 'dart:io';

import 'core/home_path.dart';
import 'core/directory.dart';

// Manages the creation of bash executables.
class BashFileManager {
  BashFileManager({this.filePath, this.gitCachePath}) {
    gitCachePath ??= '${homePath()}/.fastcli/cache/git/';
    filePath ??= '${homePath()}/.fastcli/bin';
  }

  String filePath;
  String gitCachePath;

  // Create a executable named 'name'.
  Future<void> createExecutable(String name) async {
    final directory = Directory(filePath);
    final file = File('$filePath/$name');
    if (!await directory.exists()) {
      await directory.createRecursive();
    }

    await file.create();
    await file.writeAsString(createBashFileData(name));
    await configFileAsExecutable('chmod', ['+x', '$name'], filePath);
  }

  Future<void> removeExecutable(String name) async {
    var file = File('$filePath/$name');
    await file.delete();
  }

  Future<bool> cloneRepository(String repositoryUrl, String path) async {
    // Remove a old version from cache
    final directory = Directory(path);

    if (await directory.exists()) {
      await directory.clear();
    } else {
      await directory.createRecursive();
    }

    final process = await Process.start('git', ['clone', repositoryUrl],
            runInShell: true, workingDirectory: gitCachePath)
        .then((result) async {
      await stdout.addStream(result.stdout);
      await stderr.addStream(result.stderr);
      return result;
    });

    final processResult = await process.exitCode;

    if (processResult == 0) return true;
    return false;
  }

  Future<void> removeCachedRepository(String path) async {
    final directory = Directory(path);
    if (await directory.exists()) {
      await directory.delete(recursive: true);
    }
  }

  Future<bool> configFileAsExecutable(
      String name, List<String> args, String path) async {
    final process = await Process.start(name, args,
            runInShell: true, workingDirectory: path)
        .then((result) async {
      await stdout.addStream(result.stdout);
      await stderr.addStream(result.stderr);
      return result;
    });
    final processResult = await process.exitCode;

    if (processResult == 0) return true;
    return false;
  }

  // Return the bash file data to execute a plugin.
  String createBashFileData(String name) {
    return ''' 
#!/bin/bash
fast load_plugin $name \$1 \$2 \$3 \$4 \$5 \$6 \$7 \$8 \$9
''';
  }
}
