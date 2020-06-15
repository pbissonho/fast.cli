import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:fast/actions/create_template.dart';
import 'package:fast/commands/flutter/create_template.dart';
import 'package:fast/yaml_manager.dart';
import 'package:test/test.dart';

main() {
  test('Yaml Template', () {
    var yamlTemplate = YamlTemplateReader('test/bloc_template/template.yaml');
    var template = yamlTemplate.reader();

    print(template);
  });

  test('test replacer', () {
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
  });

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
  });

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
  });
}

var tamplatesFolder = '/home/pedro/Documentos/fastz_resources/';
