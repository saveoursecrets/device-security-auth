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

  /// Checks whether biometric authentication is available on the device.
  ///
  /// Returns `true` if biometric authentication is available, `false` otherwise.
  Future<bool> canAuthenticate() {
    throw UnimplementedError('canAuthenticate() has not been implemented.');
  }

  /// Requests biometric authentication using the Flutter Local Authentication plugin.
  ///
  /// This method triggers a biometric authentication prompt, allowing the user to
  /// authenticate using their fingerprint, face, or other biometric methods
  /// supported by the device. If the user successfully authenticates, the method
  /// returns `true`. If authentication fails or is canceled, it returns `false`.
  Future<bool> authenticate({bool allowReuse = false}) {
    throw UnimplementedError('authenticate() has not been implemented.');
  }

  Future<void> setLocalizationModel(
      Map<String, dynamic> localizationModel) async {
    throw UnimplementedError(
        'setLocalizationModel() has not been implemented.');
  }
  
  /// Sets whether biometrics are required (iOS only).
  Future<void> setBiometricsRequired(
      bool biometricsRequired) {
    throw UnimplementedError(
        'setBiometricsRequired() has not been implemented.');
  }
}
