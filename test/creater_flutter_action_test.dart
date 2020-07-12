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

    var process = FastProcessCLI();
    var createrFlutter = CreaterFlutterAction(appName, args, process);
    await createrFlutter.execute();
  });

  /*
  test('create command', () async {
    var commandRunner = CommandRunner('Fast CLI', 'An incredible Dart CLI.');
    var storage = ConfigStorage('test/resources/fast_config.json');
    var fastzCLI = FastCLI(storage, commandRunner, CliConfigStorage());
    await fastzCLI.setupCommandRunnerCli(false);
    fastzCLI.addCommand(
        FlutterCreaterComand(await storage.getValue(ConfigKeys.scaffoldsPath)));
    await fastzCLI
        .run(['create', '--name', 'myapp', '--scaffold', 'mobx'], false);
  });*/
}
