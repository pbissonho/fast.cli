import 'bash_manager.dart';

class WindowsManager extends BashFileManager {
  @override
  Future<void> createExecutable(String name) {}

  @override
  Future<bool> configFileAsExecutable(
      String name, List<String> args, String path) {}
  @override
  Future<void> removeExecutable(String name) {}
}
