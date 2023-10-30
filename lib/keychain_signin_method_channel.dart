import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'keychain_signin_platform_interface.dart';

/// An implementation of [KeychainSigninPlatform] that uses method channels.
class MethodChannelKeychainSignin
    extends KeychainSigninPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('keychain_signin');

  /// Checks whether biometric authentication is available on the device.
  ///
  /// Returns `true` if biometric authentication is available, `false` otherwise.
  /// This method communicates with the native platform to determine if biometric
  /// authentication methods such as fingerprint or face recognition are supported.
  ///
  /// Returns `true` if biometric authentication is available, `false` otherwise.
  ///
  /// Throws an exception if there's an issue checking the device's support for
  /// biometric authentication.
  @override
  Future<bool> canAuthenticate() async {
    return await methodChannel.invokeMethod<bool>('canAuthenticate') ?? false;
  }

  /// Requests biometric authentication using the Flutter Local Authentication plugin.
  ///
  /// This method triggers a biometric authentication prompt, allowing the user to
  /// authenticate using their fingerprint, face, or other biometric methods
  /// supported by the device. If the user successfully authenticates, the method
  /// returns `true`. If authentication fails or is canceled, it returns `false`.
  ///
  /// Note: Biometric authentication must be available on the device, and the user
  /// must have set up biometrics in their device settings for this method to work.
  ///
  /// Returns `true` if authentication succeeds, `false` otherwise.
  ///
  /// Throws an exception if there's an issue with the authentication process.
  @override
  Future<bool> authenticate({bool allowReuse = false}) async {
    return await methodChannel.invokeMethod<bool>('authenticate', {'allowReuse': allowReuse}) ?? false;
  }

  @override
  Future<void> setLocalizationModel(
      Map<String, dynamic> localizationModel) async {
    await methodChannel.invokeMethod('setLocalizationModel', localizationModel);
  }

  @override
  Future<void> setBiometricsRequired(
      bool biometricsRequired) async {
    await methodChannel.invokeMethod('setBiometricsRequired', {'biometricsRequired': biometricsRequired});
  }
}
