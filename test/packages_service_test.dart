import 'package:tena/services/packages_service.dart';
import 'package:test/test.dart';

void main() {
  test('Pub test', () async {
    var package = await PackagesService().fetchPackage('tutuca');

    print(package);
  });
}
