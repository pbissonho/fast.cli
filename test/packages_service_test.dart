import 'package:fast/services/packages_service.dart';
import 'package:test/test.dart';

void main() {
  test('should get a package', () async {
    final package = await PackagesService().fetchPackage('koin');

    expect(package, isNotNull);
    expect(package.name, 'koin');
  });

  test('should not get a package that does not exist', () async {
    final packagesService = await PackagesService();

    expect(() => packagesService.fetchPackage('fdsfsdf'),
        throwsA((value) => value is Exception));
  });
}
