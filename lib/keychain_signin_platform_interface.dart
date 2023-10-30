import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'keychain_signin_method_channel.dart';

/// An abstract platform interface for the Keychain Signin plugin.
///
/// This platform interface defines the methods that must be implemented by
/// platform-specific classes to provide biometric authentication functionality.
abstract class KeychainSigninPlatform extends PlatformInterface {
  KeychainSigninPlatform() : super(token: _token);

  static final Object _token = Object();

  static KeychainSigninPlatform _instance =
      MethodChannelKeychainSignin();

  /// The default instance of [KeychainSigninPlatform] to use.
  ///
  /// Defaults to [MethodChannelKeychainSignin].
  static KeychainSigninPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [KeychainSigninPlatform] when
  /// they register themselves.
  static set instance(KeychainSigninPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
  
  /// Save an account password.
  Future<bool> saveAccountPassword({
    required String serviceName,
    required String accountName,
    required String password,
  }) async {
    throw UnimplementedError('saveAccountPassword() has not been implemented.');
  }

  /// Read an account password.
  Future<String?> readAccountPassword({
    required String serviceName,
    required String accountName,
  }) async {
    throw UnimplementedError('readAccountPassword() has not been implemented.');
  }

  Future<void> setLocalizationModel(
      Map<String, dynamic> localizationModel) async {
    throw UnimplementedError(
        'setLocalizationModel() has not been implemented.');
  }
}
