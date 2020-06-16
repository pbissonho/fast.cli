import 'package:fast/services/packages_service.dart';
import 'package:test/test.dart';

void main() {
  test('shoud get a package', () async {
    var package = await PackagesService().fetchPackage('koin');

    expect(package, isNotNull);
    expect(package.name, 'koin');
  });

  test('shoud not get a package that does not exist', () async {
    var packagesService = await PackagesService();

    expect(() => packagesService.fetchPackage('fdsfsdf'),
        throwsA((value) => value is Exception));
  });
}
