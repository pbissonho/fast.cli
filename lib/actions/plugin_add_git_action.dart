import 'package:fast/core/action.dart';
import 'package:path/path.dart';

import '../bash_manager.dart';
import '../config_storage.dart';
import '../logger.dart';
import '../yaml_manager.dart';

class PluginAddGitAction implements Action {
  final PluginStorage storage;
  final BashFileManager bashFileManager;
  String _gitUrl;

  PluginAddGitAction(this.storage, this.bashFileManager);

  void setUrl(String url) {
    _gitUrl = url;
  }

  @override
  Future<void> execute() async {
    var pathOnlyBaseName = basename(_gitUrl);
    var repositoryName = withoutExtension(pathOnlyBaseName);
    var path = normalize('${bashFileManager.gitCachePath}/$repositoryName/');

    await bashFileManager.cloneRepository(_gitUrl, path);

    var yamlPlugin = YamlManager.readerYamlPluginFile('$path/plugin.yaml');
    var plugin = Plugin(git: _gitUrl, path: path, name: yamlPlugin.name);
    await storage.add(plugin);
    await bashFileManager.createExecutable(yamlPlugin.name);
    logger.d('Plugin(${yamlPlugin.name}) - Resources successfully configured.');
    logger.d('Executable: ${yamlPlugin.name} - Globally configured');
  }

  @override
  String get succesMessage => 'Executable for ${_gitUrl} configured.';
}
