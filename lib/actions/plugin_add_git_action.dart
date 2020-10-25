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
  String _path = '';

  PluginAddGitAction(this.storage, this.bashFileManager);

  void setUrl(String url) {
    _gitUrl = url;
  }

  void withPath(String path) {
    _path = path;
  }

  @override
  Future<void> execute() async {
    var pathOnlyBaseName = basename(_gitUrl);
    var repositoryName = withoutExtension(pathOnlyBaseName);
    var localPath =
        normalize('${bashFileManager.gitCachePath}/$repositoryName/');

    await bashFileManager.cloneRepository(_gitUrl, localPath);

    var yamlPlugin = YamlManager.readerYamlPluginFile(
        normalize('$localPath/$_path/plugin.yaml'));
    
    var plugin = Plugin(
        git: _gitUrl,
        path: normalize('$localPath/$_path'),
        name: yamlPlugin.name);

    await storage.add(plugin);
    await bashFileManager.createExecutable(yamlPlugin.name);
    logger.d('Plugin(${yamlPlugin.name}) - Resources successfully configured.');
    logger.d('Executable: ${yamlPlugin.name} - Globally configured');
  }

  @override
  String get succesMessage => 'Executable for ${_gitUrl} configured.';
}
