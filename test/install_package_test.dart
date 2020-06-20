import 'package:fast/actions/add_pachage.dart';
import 'package:fast/core/exceptions.dart';
import 'package:test/test.dart';

void main() {
  test('shoud install package', () async {
    var addPackageAction =
        AddPackage('koin', 'test/resources/_pubspec.yaml', false);
    await addPackageAction.execute();
  });

   test('shoud install a dev package', () async {
    var addPackageAction =
        AddPackage('koin', 'test/resources/_pubspec.yaml', true);
    await addPackageAction.execute();
  });

  test('shoud not install package', () async {
    var addPackageAction =
        AddPackage('konidfsdf', 'test/resources/_pubspec.yaml', false);
    expect(() => addPackageAction.execute(),
        throwsA((value) => value is FastException));
  });
}
