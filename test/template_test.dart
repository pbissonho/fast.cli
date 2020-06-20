import 'package:fast/yaml_manager.dart';
import 'package:test/test.dart';

void main() {
  test('shoud reader yaml template file', ()async {
    var yamlTemplate = await YamlTemplateReader('test/resources/template.yaml');
    var template = yamlTemplate.reader();

    print(template);
  });

  test('shoud load all templates', () async{
    var templates = await YamlManager.loadTemplates('test/resources/templates/');

    expect(templates.length, 2);
  });

  test('shoud not have snippets', () async {
    var templates = await YamlManager.loadTemplates('test/resources/templates/');

    expect(false, templates.firstWhere((tem) => tem.name == 'bloc').hasSnippets());
  });

  test('shoud have snippets', () async {
    var templates = await YamlManager.loadTemplates('test/resources/templates/');

    expect(true, templates.firstWhere((tem) => tem.name == 'page').hasSnippets());
  });

  /*
  test('shoud load all templates', () {
    var yamlTemplate = YamlTemplateReader('test/bloc_template/template.yaml');
    var template = yamlTemplate.reader();

    var replacers = <Replacer>[];

    template.args.forEach((arg) {
      replacers.add(Replacer(arg, 'XXKL'));
    });

    var myString = ''' 
        @name# : tutuca
        @name#Event

        @size#Test   
    ''';

    for (var replacer in replacers) {
      myString = replacer.replace(myString);
    }

    print(myString);
  });*/
}

/* 
  test('Create tample teste', () async {
    var tamplates = await YamlManager.loadTemplates(tamplatesFolder);

    var createTamplate = CreateTemplateAction(
        YamlTemplateReader('test/bloc_template/template.yaml').reader(),
        'test/bloc_template/', {});

    await createTamplate.execute();

    var directory = Directory('criado/');
    await directory.create();

    createTamplate.templateFiles.forEach((f) {
      var file = File('${directory.path}/${f.name}');
      file.writeAsString(f.content);
    });

    print(createTamplate.templateFiles);
  }, skip: true);

  test('Create tamplate test', () async {
    var tamplates = await YamlManager.loadTemplates(tamplatesFolder);

    var template = tamplates.firstWhere((temp) => temp.name == 'bloc');

    var commandRunner = CommandRunner('Test', 'Test');
    commandRunner.addCommand(CreateTemplateCommand(
        template: template,
        templateFolderPath: '${tamplatesFolder}/${template.name}_template',
        templateYamlPath:
            '${tamplatesFolder}/${template.name}_template/template.yaml'));
    await commandRunner.run(['bloc', '--name', 'counter']);
  });

  test('test load templates', () async {
    var tamplates = await YamlManager.loadTemplates(tamplatesFolder);
    print(tamplates);
  }, skip: true);
}

var tamplatesFolder = '/home/pedro/Documentos/fastz_resources/';
*/
