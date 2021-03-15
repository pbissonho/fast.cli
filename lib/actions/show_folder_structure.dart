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

import 'package:fast/core/action.dart';
import 'package:fast/logger.dart';
import 'package:fast/yaml_manager.dart';

class ShowFolderStructure implements Action {
  final Folder folder;

  ShowFolderStructure(this.folder);

  @override
  Future<void> execute() async {
    logger.d('Structure: \n-----------');

    folder.subFolders.forEach((folder) {
      showFolders(2, folder);
    });
  }

  void showFolders(int sub, Folder folder) {
    sub += 2;
    logger.d(' ' * sub + '${folder.name}');
    for (final subFolder in folder.subFolders) {
      showFolders(sub, subFolder);
    }
  }

  @override
  String get succesMessage => '-----------';
}
