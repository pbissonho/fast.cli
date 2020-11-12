import 'dart:io';

import 'package:fast/core/action.dart';

class AddMainFile implements Action {
  final String path;
  final File main;

  AddMainFile({this.path, this.main});

  @override
  Future<void> execute() async {
    await main.copy(path);
    await main.delete(recursive: true);
  }

  @override
  String get succesMessage => 'Main file was recreated';
}
