import 'package:fast/services/packages_service.dart';
import 'package:test/test.dart';

void main() {
  test('shoud get a package', () async {
    var package = await PackagesService().fetchPackage('koin');

    expect(package, isNotNull);
    expect(package.name, 'koin');
  });
}
