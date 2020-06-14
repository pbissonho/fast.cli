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
import 'package:tena/core/action.dart';
import 'package:tena/core/directory/directory.dart';
import 'package:tena/yaml_manager.dart';

class CreateProjectStructure extends CreateFolderStructure {
  CreateProjectStructure(String path, Folder folder) : super(path, folder);

  @override
  String get actionName => 'Create project structure.';
}

class CreateFolderStructure implements Action {
  final String path;
  final Folder folder;

  CreateFolderStructure(this.path, this.folder);

  @override
  Future<void> execute() async {
    await createrDirectorys(folder.subFolders, path);
  }

  Future<void> createrDirectorys(List<Folder> folders, path) async {
    await folders.forEach((folder) async {
      await createFolderDirectory(path, folder);
    });
  }

  Future<void> createFolderDirectory(String parentPath, Folder folder) async {
    await Directory('$parentPath/${folder.name}').createRecursive();
    folder.subFolders.forEach((subFolder) {
      createFolderDirectory('$parentPath/${folder.name}', subFolder);
    });
  }

  Future<void> createFolderFile(YamlFile fileSource) async {
    var file = await File('${fileSource.name}${fileSource.extension}');
    await file.create();
  }

  @override
  String get actionName => 'Create folder structure.';
}
