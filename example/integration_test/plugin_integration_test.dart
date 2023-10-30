import 'package:keychain_signin/keychain_signin.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('canAuthenticate test', (WidgetTester tester) async {
    final KeychainSignin plugin = KeychainSignin();
    final bool canAuthenticate = await plugin.canAuthenticate();
    expect(canAuthenticate, true);
  });
}
