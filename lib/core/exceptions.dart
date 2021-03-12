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

class FastException implements Exception {
  final String msg;
  FastException(this.msg);

  @override
  String toString() {
    return '$runtimeType: $msg';
  }
}

class UnsupportedPlatformException implements Exception {
  final String msg =
      'Platform not compatible with Fast CLI. Use Windows, Linux or MacOS.';
  UnsupportedPlatformException();

  @override
  String toString() {
    return '$runtimeType: $msg';
  }
}
