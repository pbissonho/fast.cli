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

class ActionBuilder implements Action {
  List<Action> _actions;

  List<Action> get actions => _actions;

  ActionBuilder([this._actions]) {
    _actions ??= <Action>[];
  }

  void add(Action action) {
    _actions.add(action);
  }

  void addAll(List<Action> actions) {
    _actions.addAll(actions);
  }

  @override
  Future<void> execute() async {
    for (var action in actions) {
      await action.execute();
      logger.d(action.succesMessage);
    }
  }

  @override
  String get succesMessage => 'Actino builder.';
}
