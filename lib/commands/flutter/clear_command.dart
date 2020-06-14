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

import 'package:flunt_dart/flunt_dart.dart';
import '../../logger.dart';
import 'package:tena/core/directory/directory.dart';

import '../command_base.dart';

class ClearCommand extends CommandBase {
  @override
  String get description => 'Clear the lib and test folders.';

  @override
  String get name => 'clear';

  String get finishedDescription => 'Cleaned the lib and test folders.';

  ClearCommand();

  @override
  Future<void> run() async {
    var dir = 'lib';
    logger.d('Action: Clear');
    logger.d('dir: $dir');

    var directory = Directory('lib');
    logger.d('dir: ${directory.absolute}${directory.path}');
    await directory.clear();
    await Directory('test').clear();

    validate(Contract('', ''));

    logger.d('${runtimeType.toString()} finished. - $finishedDescription');
  }
}
