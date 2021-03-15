import '../command_base.dart';

// TODO
class UnistallPackageCommand extends CommandBase {
  @override
  String get description => 'Remove a package to the dependencies.';

  @override
  String get name => 'unistall';

  String get finishedDescription => 'Remove a package to the dependencies.';

  UnistallPackageCommand();

  @override
  Future<void> run() async {
    //final packageName = argResults.rest[0];
    //final packageVersion = argResults['version'];
    //final addPackageAction = AddPackage(packageName, 'pubspec.yaml', '');
    //await addPackageAction.execute();
    //logger.d('${runtimeType.toString()} finished. - $finishedDescription');
  }
}
