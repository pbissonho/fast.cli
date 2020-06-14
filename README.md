# Tenaz CLI
 
An incredible command line interface for Flutter.

With this CLI, you can create your custom templates and define how your project will start.

The generated directories and files are defined from the outside in, that is, the users define the templates, the CLI only creates them.

That way you are not forced to use the project structure set by someone else and you can easily modify templates already created.

## Features
- Templates generator
- Aplication Scaffold generator
- Custom commands
- Standard line commands (Some commands already included in the CLI)
    - install (Add a package to the project dependencies)
    - unistall (Remove a package to the project dependencies)


## Template generator example

### Template example:

First we define the files that are generated.
In this example, the '@Name' tag will be replaced by the '--name' argument when the file is generated.

file: @name_page.dart
```dart
import 'package:flutter/material.dart';

class @NamePage extends StatefulWidget {
  @override
  _@NamePageState createState() => _@NamePageState();
}

class _@NamePageState extends State<@NamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text("Hello"),
      ),
    );
  }
}
```
In the same folder as the file above we have the yaml file that defines how the template should be created.

file: template.yaml
```yaml
#Yaml file for configuring the template.
#The template name
name: page
#The template description
description: Create_flutter_page.
#Path where files should be sent
to: lib/ui/pages/@name
#Arguments to be passed when executing this template
# You can define as many arguments as you want.
args:
  - name
# - other1
# - other2
# - other3
```

### Running the template

Run this command so that your template is generated.

tenaz <template_name>  <templates_arg1, templates_arg1, templates_arg1....>

Example:
run on cmd:
tenaz page --name home

### Result 

You will now have the following file in the path `lib/ui/pages/home`

```dart
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text("Hello"),
      ),
    );
  }
}
```

## Scaffold generator exemple

### Scaffold example:

file: scaffold.yaml
```yaml
# The scaffold name.
name: sample
description: A sample scaffold.
author: Pedro Bissonho <pedro.bissonho@gmail.com>

# The folder structure that will be generated inside the 'lib' folder.
structure:
  - ui:
    - pages
    - shared 
    - themes
  - data:
    - models
    - repositorys
  - blocs
# The folder structure that will be generated inside the 'test' folder.
test_structure:
  - ui:
  - data:
  - fixtures:

# The standard dependencies that the project will have.
# Your project will start with all these dependencies.
# If the version is not informed, the version will be configured as the last version available in Dart Pub.
dependencies: 
  koin: 
  flutter_bloc: 

# The standard dev_dependencies that the project will have.
dev_dependencies:
  koin_test:  
```

### Create a APP with the sample scaffold

Run this command for your application to be created.

tena create --name <app_name> --scafoold <scafoold_name> 

run on cmd:
tena create --name myapp --scafoold sample

### Result 

An application created with structure and dependencies selects no sample of scaffolding.

![alt text](scaffold.png)

## Commands example 

### Commands YAML example:

file: commands.yaml
```yaml
commands:
  runner: flutter build runner build
  push: git push origin master
  mkdir: mkdir myFolder
```

### Running a command

tenaz run <command_name>

Example:
tenaz run runner


# Setup

## Install

Install this package globally. To do this, you must have the Dart SDK [installed and configured](https://dart.dev/get-dart) 

run on cmd: 
pub global activate tenaz

## Config

Configure the path of the templates that will be used by the CLI.

run on cmd: 
tena config templates <templates_path>
tena config projects <projects_path>

Exemple: 

tena config templates /home/pedro/Documentos/templates/
tena config projects /home/pedro/Documentos/projects/

# License

[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).