//Copyright 2020 Pedro Bissonho
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

import 'dart:io';

class FastProcess {
  Future<bool> executeProcess(
      String name, List<String> args, String path) async {
    final process = await Process.start(name, args,
        runInShell: true, workingDirectory: path);
    final processExitCode = await process.exitCode;
    if (processExitCode == 0) return true;
    return false;
  }

  Future<bool> executeProcessShellPath(
      String name, List<String> args, String path) async {
    final process = await Process.start(name, args, runInShell: false);
    final processExitCode = await process.exitCode;
    if (processExitCode == 0) return true;
    return false;
  }
}

class FastProcessCLI implements FastProcess {
  @override
  Future<bool> executeProcess(
      String name, List<String> args, String path) async {
    final process =
        await Process.start(name, args, runInShell: true).then((result) async {
      await stdout.addStream(result.stdout);
      await stderr.addStream(result.stderr);
      return result;
    });

    final processExitCode = await process.exitCode;

    if (processExitCode == 0) return true;
    return false;
  }

  @override
  Future<bool> executeProcessShellPath(
      String name, List<String> args, String path) async {
    final process =
        await Process.start(name, args, runInShell: true).then((result) async {
      await stdout.addStream(result.stdout);
      await stderr.addStream(result.stderr);
      return result;
    });

    final processExitCode = await process.exitCode;

    if (processExitCode == 0) return true;
    return false;
  }
}
