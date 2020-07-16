import 'dart:io';

import 'core/home_path.dart';
import 'core/directory/directory.dart';

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
    var directory = Directory(filePath);
    var file = File('$filePath/$name');
    if (!await directory.exists()) {
      await directory.createRecursive();
    }

    await file.create();
    await file.writeAsString(createBashFileData(name));
    var path = '${homePath()}/.fastcli/bin/';
    var result = await configFileAsExecutable('chmod', ['+x', '$name'], path);
  }

  Future<void> removeExecutable(String name) async {
    var file = File('$filePath/$name');
    await file.delete();
  }

  Future<bool> cloneRepository(String repositoryUrl, String path) async {
    // Remove a old version from cache
    var dire = Directory(path);

    if (await dire.exists()) {
      await dire.clear();
    } else {
      await dire.createRecursive();
    }

    var process = await Process.start('git', ['clone', repositoryUrl],
            runInShell: true, workingDirectory: gitCachePath)
        .then((result) async {
      await stdout.addStream(result.stdout);
      await stderr.addStream(result.stderr);
      return result;
    });

    var result = await process.exitCode;

    if (result == 0) return true;
    return false;
  }

  Future<void> removeCachedRepository(String path) async {
    var dire = Directory(path);
    if (await dire.exists()) {
      await dire.delete(recursive: true);
    }
  }

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

  // Return the bash file data to execute a plugin.
  String createBashFileData(String name) {
    return ''' 
#!/bin/bash
fast load_plugin $name \$1 \$2 \$3 \$4 \$5 \$6 \$7 \$8 \$9
''';
  }
}
