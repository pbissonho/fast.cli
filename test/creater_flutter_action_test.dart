import 'package:fast/actions/create_project_action.dart';
import 'package:fast/core/fast_process.dart';
import 'package:test/test.dart';

void main() {
  test('should create a Flutter Project', () async {
    final appName = 'tutuca';

    final args = FlutterAppArgs(
        useAndroidX: false,
        name: appName,
        description: 'vem_tutuca',
        useKotlin: false,
        useSwift: false);

    final process = FastProcessCLI();
    final createrFlutter = CreateProjectAction(appName, args, process);
    await createrFlutter.execute();
  });

  /*
  test('create command', () async {
    final commandRunner = CommandRunner('Fast CLI', 'An incredible Dart CLI.');
    final storage = ConfigStorage('test/resources/fast_config.json');
    final fastzCLI = FastCLI(storage, commandRunner, CliConfigStorage());
    await fastzCLI.setupCommandRunnerCli(false);
    fastzCLI.addCommand(
        FlutterCreaterComand(await storage.getValue(ConfigKeys.scaffoldsPath)));
    await fastzCLI
        .run(['create', '--name', 'myapp', '--scaffold', 'mobx'], false);
  });*/
}
