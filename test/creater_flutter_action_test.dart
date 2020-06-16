import 'package:fast/actions/creater_flutter_action.dart';
import 'package:fast/commands/flutter/create_flutter_comand.dart';
import 'package:fast/core/process_extension.dart';
import 'package:test/test.dart';

void main() {
  test('Shoud create a Flutter Project', () async {
    var appName = 'tutuca';

    var args = FlutterAppArgs(
        useAndroidX: false,
        name: appName,
        description: 'vem_tutuca',
        useKotlin: false,
        useSwift: false);

    var createrFlutter = CreaterFlutterAction(appName, args, FastProcess());

    await createrFlutter.execute();

    //var createStructAction = CreateProjectStructure(
    //    '$appName/lib', yamlManager.structure.mainFolder);
    //await createStructAction.execute();
  }, skip: true);
}
