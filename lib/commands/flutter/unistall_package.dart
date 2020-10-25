import '../command_base.dart';

class UnistallPackageCommand extends CommandBase {
  @override
  String get description => 'Remove a package to the dependencies.';

  @override
  String get name => 'unistall';

  String get finishedDescription => 'Remove a package to the dependencies.';

  UnistallPackageCommand();

  @override
  Future<void> run() async {
    //var packageName = argResults.rest[0];
    // var packageVersion = argResults['version'];
    //var addPackageAction = AddPackage(packageName, 'pubspec.yaml', '');
    //await addPackageAction.execute();
    //logger.d('${runtimeType.toString()} finished. - $finishedDescription');
  }
}
