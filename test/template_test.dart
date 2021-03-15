import 'package:args/command_runner.dart';
import 'package:fast/actions/create_template.dart';
import 'package:fast/config_storage.dart';
import 'package:fast/fast.dart';
import 'package:fast/yaml_manager.dart';
import 'package:test/test.dart';

void main() {
  test('should reader yaml template file', () async {
    final yamlTemplate =
        await YamlTemplateReader('test/resources/template.yaml');
    final template = yamlTemplate.reader();

    print(template);
  });

  test('should load all templates', () async {
    final templates =
        await YamlManager.loadTemplates('test/resources/templates/');

    expect(templates.length, 2);
  });

  test('should not have snippets', () async {
    final templates =
        await YamlManager.loadTemplates('test/resources/templates/');

    expect(
        false, templates.firstWhere((tem) => tem.name == 'bloc').hasSnippets());
  });

  test('should have snippets', () async {
    final templates =
        await YamlManager.loadTemplates('test/resources/templates/');

    expect(
        true, templates.firstWhere((tem) => tem.name == 'page').hasSnippets());
  });

  test('should create template', () async {
    final path = 'test/resources/templates/bloc_template/';
    final tamplate = await YamlTemplateReader('$path/template.yaml').reader();
    final createTamplate = CreateTemplateAction(tamplate, {'name': 'counter'});
    await createTamplate.execute();
  });

  test('should create a tamplate - FAST CLI', () async {
    final commandRunner = CommandRunner('Fast CLI', 'An incredible Dart CLI.');
    final fastzCLI = FastCLI(commandRunner, PluginStorage());
    await fastzCLI.setupCommandRunner('mvc');
    await fastzCLI.run(
        ['fast', 'cli', 'mvc', 'controller', '--name', 'myController'], true);
  });

  test('should not throw an error when template is empty', () async {
    final templates =
        await YamlManager.loadTemplates('test/resources/empty_templates/');

    expect(0, templates.length);
  });
}
