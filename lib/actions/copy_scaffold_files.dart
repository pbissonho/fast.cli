import 'dart:io';

import '../logger.dart';
import '../core/action.dart';
import '../core/directory/directory.dart';
import '../yaml_manager.dart';
import 'create_template.dart';

const String appNameKey = 'appName';

class CopyScaffoldFiles implements Action {
  final String path;
  final String appName;
  final bool activated;

  CopyScaffoldFiles(this.path, this.appName, this.activated);

  @override
  Future<void> execute() async {
    if (!activated) return null;

    var filesExistsAndHasContent = await Directory(path).existsFiles();
    if (!filesExistsAndHasContent) return null;

    Directory(path)
        .listSync(followLinks: true, recursive: true)
        .forEach((fileEntity) {
      var template = Template(
          path: fileEntity.path,
          to: fileEntity.path.replaceFirst(path, appName),
          args: [appNameKey]);
      var argsMap = {appNameKey: appName};

      logger.d('Copying file ${fileEntity.path} to ${template.to}');

      CreateTemplateAction(template, argsMap).execute();
    });

    return null;
  }

  @override
  String get succesMessage => activated
      ? 'Scaffold files were copied successfully'
      : 'Scaffold files were not copied because it deactivated';
}
