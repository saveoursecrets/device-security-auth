import 'package:keychain_signin/keychain_signin.dart';
import 'package:keychain_signin/keychain_signin_method_channel.dart';
import 'package:keychain_signin/keychain_signin_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockKeychainSigninPlatform
    with MockPlatformInterfaceMixin
    implements KeychainSigninPlatform {
  final _canAuthenticate = true;

  @override
  Future<bool> authenticate() => Future.value(_canAuthenticate);

  @override
  Future<bool> canAuthenticate() => Future.value(_canAuthenticate);

  @override
  Future<void> setLocalizationModel(Map<String, dynamic> localizationModel) =>
      Future.value();
}

void main() {
  final KeychainSigninPlatform initialPlatform =
      KeychainSigninPlatform.instance;

  test('$MethodChannelKeychainSignin is the default instance', () {
    expect(initialPlatform,
        isInstanceOf<MethodChannelKeychainSignin>());
  });

  test('canAuthenticate', () async {
    KeychainSignin flutterLocalAuthenticationPlugin =
        KeychainSignin();
    MockKeychainSigninPlatform fakePlatform =
        MockKeychainSigninPlatform();
    KeychainSigninPlatform.instance = fakePlatform;

    expect(await flutterLocalAuthenticationPlugin.canAuthenticate(), true);
  });

  test('authenticate', () async {
    KeychainSignin flutterLocalAuthenticationPlugin =
        KeychainSignin();
    MockKeychainSigninPlatform fakePlatform =
        MockKeychainSigninPlatform();
    KeychainSigninPlatform.instance = fakePlatform;

    expect(await flutterLocalAuthenticationPlugin.authenticate(), true);
  });
}
