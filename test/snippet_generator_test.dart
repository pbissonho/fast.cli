import 'package:fast/config_storage.dart';
import 'package:fast/core/home_path.dart';
import 'package:fast/snippet_manager.dart';
import 'package:fast/yaml_manager.dart';
import 'package:test/test.dart';

void main() {
  test('shoud create snippets global file', () async {
    var config = await ConfigStorage().getConfig();
    var templates = await YamlManager.loadTemplates(config.templatesPath);

    final globalSnippetsPath =
        '${homePath()}/.config/Code/User/snippets/created.code-snippets';
    await SnippetGenerator(templates, config, globalSnippetsPath)
        .generateSnippedFile();
  }, timeout: Timeout(Duration(minutes: 10)));
}
