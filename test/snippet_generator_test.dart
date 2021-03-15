import 'package:fast/snippet_manager.dart';
import 'package:fast/yaml_manager.dart';
import 'package:test/test.dart';

void main() {
  test(
    'should create snippets global file',
    () async {
      final templates =
          await YamlManager.loadTemplates('test/resources/templates');
      //final globalSnippetsPath =
      //     '${homePath()}/.config/Code/User/snippets/created.code-snippets';

      final globalSnippetsPath = 'test/resources/snippets.json';
      await SnippetGenerator(
              templates.where((temp) => temp.hasSnippets()).toList(),
              'test/resources/templates',
              globalSnippetsPath)
          .generateSnippedFile();
    },
  );
}
