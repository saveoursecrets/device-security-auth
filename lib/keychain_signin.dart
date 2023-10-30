import 'dart:io';

import 'package:keychain_signin/localization_model.dart';

import 'keychain_signin_platform_interface.dart';

/// Plugin for  authentication using the Security and 
/// LocalAuthentication frameworks.
class KeychainSignin {

  Future<bool> saveAccountPassword({
    required String serviceName,
    required String accountName,
    required String password,
  }) async {
    return await KeychainSigninPlatform.instance
        .saveAccountPassword(
          serviceName: serviceName,
          accountName: accountName,
          password: password,
    );
  }

  Future<String?> readAccountPassword({
    required String serviceName,
    required String accountName,
  }) async {
    return await KeychainSigninPlatform.instance
        .readAccountPassword(
          serviceName: serviceName,
          accountName: accountName,
    );
  }

  /// Sets the [LocalizationModel] for the plugin.
  ///
  /// This method allows you to specify a [LocalizationModel] to customize
  /// the localized strings used in the biometric authentication prompts.
  ///
  /// Parameters:
  ///
  /// - `localizationModel`: A [LocalizationModel] containing the customized
  ///   strings for localization.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// LocalizationModel customLocalization = LocalizationModel(
  ///   promptDialogTitle: 'Custom Title',
  ///   promptDialogReason: 'Custom Reason',
  ///   cancelButtonTitle: 'Custom Cancel',
  /// );
  ///
  /// plugin.setLocalizationModel(customLocalization);
  /// ```
  ///
  /// Note: If you do not set a [LocalizationModel], the plugin will use
  /// default localized strings in English.
  void setLocalizationModel(LocalizationModel localizationModel) async {
    await KeychainSigninPlatform.instance.setLocalizationModel(
      localizationModel.toJson());
  }
}
