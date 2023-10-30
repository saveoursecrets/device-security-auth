import 'package:flutter/services.dart';
import 'package:keychain_signin/keychain_signin_method_channel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelKeychainSignin platform =
      MethodChannelKeychainSignin();
  const MethodChannel channel = MethodChannel('keychain_signin');

  double testTouchIDAuthenticationAllowableReuseDuration = 0.0;

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case "canAuthenticate":
            return true;
          case "authenticate":
            return true;
        }
        return null;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('canAuthenticate', () async {
    expect(await platform.canAuthenticate(), true);
  });

  test('authenticate', () async {
    expect(await platform.authenticate(), true);
  });
}
