import 'package:fast/actions/create_template.dart';
import 'package:fast/config_storage.dart';
import 'package:fast/yaml_manager.dart';
import 'package:test/test.dart';

void main() {
  test('shoud reader yaml template file', () async {
    var yamlTemplate = await YamlTemplateReader('test/resources/template.yaml');
    var template = yamlTemplate.reader();

    print(template);
  });

  test('shoud load all templates', () async {
    var templates =
        await YamlManager.loadTemplates('test/resources/templates/');

    expect(templates.length, 2);
  });

  test('shoud not have snippets', () async {
    var templates =
        await YamlManager.loadTemplates('test/resources/templates/');

    expect(
        false, templates.firstWhere((tem) => tem.name == 'bloc').hasSnippets());
  });

  test('shoud have snippets', () async {
    var templates =
        await YamlManager.loadTemplates('test/resources/templates/');

    expect(
        true, templates.firstWhere((tem) => tem.name == 'page').hasSnippets());
  });

  test('shoud create template', () async {
    var path = 'test/resources/templates/bloc_template/';
    var tamplate = await YamlTemplateReader('$path/template.yaml').reader();
    var createTamplate = CreateTemplateAction(tamplate, {'name': 'counter'});
    await createTamplate.execute();
  });

  test('shoud create', () async {
    var fastStorage = ConfigStorage();
    var templatesPath = await fastStorage.getValue(ConfigKeys.templatesPath);
    var templates = YamlManager.loadTemplates(templatesPath);
    var actions = <CreateTemplateAction>[];
    templates.forEach((temp) {
      actions.add(CreateTemplateAction(temp, {'name': 'counter'}));
    });

    await actions.first.execute();
  });
}
