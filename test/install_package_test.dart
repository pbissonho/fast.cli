import 'package:fast/actions/add_pachage.dart';
import 'package:fast/core/exceptions.dart';
import 'package:test/test.dart';

void main() {
  test('should install package', () async {
    final addPackageAction =
        AddPackage('koin', 'test/resources/_pubspec.yaml', false);
    await addPackageAction.execute();
  });

  test('should install a dev package', () async {
    final addPackageAction =
        AddPackage('koin', 'test/resources/_pubspec.yaml', true);
    await addPackageAction.execute();
  });

  test('should not install package', () async {
    final addPackageAction =
        AddPackage('konidfsdf', 'test/resources/_pubspec.yaml', false);
    expect(() => addPackageAction.execute(),
        throwsA((value) => value is FastException));
  });
}
