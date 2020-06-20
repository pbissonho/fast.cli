//Copyright 2020 Pedro Bissonho
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

import 'package:fast/core/exceptions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const pubUrl = 'https://pub.dev/api/packages';

class PackagesService {
  Future<Package> fetchPackage(
    String packageName,
  ) async {
    var url = '$pubUrl/$packageName';

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var map = data as Map;
        return Package.fromJson(map);
      }
      throw FastException('Not found package.');
    } catch (e) {
      throw FastException(
          '''An error occurs when picking up the package $packageName 
Check that the package name is valid.
''');
    }
  }
}

class Package {
  String name;
  Version latest;
 // List<Version> versions;

  /*
  bool hasVersion(String version) {
    if (versions.firstWhere((v) => v.version == version) != null) return true;
    return false;
  }*/

  Package({name, latest, versions});

  Package.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    latest = json['latest'] != null ? Version.fromJson(json['latest']) : null;

    /*
    if (json['versions'] != null) {
      versions = <Version>[];
      json['versions'].forEach((v) {
        versions.add(Version.fromJson(v));
      });
    }*/
  }
}

class Version {
  String version;
//  Pubspec pubspec;
  String archiveUrl;
  String published;

  Version({version, pubspec, archiveUrl, published});

  Version.fromJson(Map<String, dynamic> json) {
    version = json['version'];
//    pubspec =
//       json['pubspec'] != null ? Pubspec.fromJson(json['pubspec']) : null;
    archiveUrl = json['archive_url'];
    published = json['published'];
  }
}

/*
class Pubspec {
  String name;
  String description;
  String version;
  String homepage;
  Environment environment;
  Dependencies dependencies;
  DevDependencies devDependencies;

  Pubspec(
      {name,
      description,
      version,
      homepage,
      environment,
      dependencies,
      devDependencies});

  Pubspec.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    version = json['version'];
    homepage = json['homepage'];
    environment = json['environment'] != null
        ? Environment.fromJson(json['environment'])
        : null;
    dependencies = json['dependencies'] != null
        ? Dependencies.fromJson(json['dependencies'])
        : null;
    devDependencies = json['dev_dependencies'] != null
        ? DevDependencies.fromJson(json['dev_dependencies'])
        : null;
  }
}

class Environment {
  String sdk;

  Environment({sdk});

  Environment.fromJson(Map<String, dynamic> json) {
    sdk = json['sdk'];
  }
}

class Dependencies {
  String path;
  String equatable;
  String ktDart;

  Dependencies({path, equatable, ktDart});

  Dependencies.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    equatable = json['equatable'];
    ktDart = json['kt_dart'];
  }
}

class DevDependencies {
  String pedantic;
  String test;
  String testCoverage;

  DevDependencies({pedantic, test, testCoverage});

  DevDependencies.fromJson(Map<String, dynamic> json) {
    pedantic = json['pedantic'];
    test = json['test'];
    testCoverage = json['test_coverage'];
  }
}

class PubspecX {
  String name;
  String description;
  String version;
  String homepage;
  String author;
  Environment environment;
  Dependencies dependencies;
  DevDependencies devDependencies;

  PubspecX(
      {name,
      description,
      version,
      homepage,
      author,
      environment,
      dependencies,
      devDependencies});

  PubspecX.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    version = json['version'];
    homepage = json['homepage'];
    author = json['author'];
    environment = json['environment'] != null
        ? Environment.fromJson(json['environment'])
        : null;
    dependencies = json['dependencies'] != null
        ? Dependencies.fromJson(json['dependencies'])
        : null;
    devDependencies = json['dev_dependencies'] != null
        ? DevDependencies.fromJson(json['dev_dependencies'])
        : null;
  }
}*/