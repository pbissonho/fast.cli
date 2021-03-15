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

import 'package:path/path.dart';

extension DirectoryExtension on Directory {
  Future<bool> clear({List<String> excludedFiles = const []}) async {
    if (await exists()) {
      await list().forEach((fileSystem) async {
        if (!excludedFiles.contains(fileSystem.path)) {
          await fileSystem.delete(recursive: true);
        }
      });
      return true;
    } else {
      return false;
    }
  }

  Future<bool> existsFiles() async {
    if (await exists()) {
      final size = await list().length;

      if (size == 1) {
        final first = await list().first;
        final last = split(first.path).last;
        if (last == '.directory') return false;
      }

      if (size > 0) {
        return true;
      }

      return false;
    }
    return false;
  }

  Future<bool> deleteIfExists() async {
    if (await exists()) {
      await delete(recursive: true);
      return true;
    } else {
      return false;
    }
  }

  Future<void> createRecursive() async {
    await create(recursive: true);
  }

  Future<List<FileSystemEntity>> getAllSystemFiles() async {
    final systemFiles = <FileSystemEntity>[];

    if (await exists()) {
      await list(recursive: true).forEach((
        fileSystem,
      ) async {
        systemFiles.add(fileSystem);
      });

      return systemFiles;
    }

    return [];
  }

  Future<List<FileSystemEntity>> getAllSystemFilesNotRecursive() async {
    final systemFiles = <FileSystemEntity>[];

    if (await exists()) {
      await list().forEach((
        fileSystem,
      ) async {
        systemFiles.add(fileSystem);
      });

      return systemFiles;
    }

    return [];
  }
}
