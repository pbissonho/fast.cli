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

class TenaException implements Exception {
  final String msg;
  TenaException(this.msg);

  @override
  String toString() {
    return '$runtimeType: $msg';
  }
}

class StorageException extends TenaException {
  StorageException(String msg) : super(msg);
}

class NotFounfTenaConfigException extends TenaException {
  NotFounfTenaConfigException(String msg) : super(msg);
}

class YamlTemplateFileException extends TenaException {
  YamlTemplateFileException(String msg) : super(msg);
}
