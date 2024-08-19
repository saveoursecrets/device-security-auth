import 'dart:io';

import 'device_security_auth_platform_interface.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'device_security_type.dart';
export 'device_security_type.dart';

const preferencesKeyPrefix = "urn:sos:";

/// Plugin for authenticating using the device's native 
/// security capabilities.
class DeviceSecurityAuth {
  DeviceSecurityAuth({
    required this.serviceName,
    // Shared preferences database name (android only).
    String? sharedPreferencesName,
    // Backwards compatibility (windows only).
    bool useBackwardCompatibility = false,
  }) {
    _secureStorage = FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
        sharedPreferencesName: sharedPreferencesName,
        preferencesKeyPrefix: preferencesKeyPrefix,
      ),
      wOptions: WindowsOptions(
        useBackwardCompatibility: useBackwardCompatibility,
      ),
    );
  }
  
  // Service name identifier.
  final String serviceName;

  // Secure storage.
  late FlutterSecureStorage _secureStorage;

  // Local device authentication.
  final LocalAuthentication _localAuth = LocalAuthentication();
  
  // Apple platform uses the Keychain backed by biometric unlock.
  bool get _isApplePlatform => Platform.isMacOS || Platform.isIOS;

  // Whether the platform supports device authentication.
  bool get supportsDeviceAuthentication {
    return _isApplePlatform || Platform.isAndroid || Platform.isWindows;
  }
  
  // Authenticate using the device biometrics or PIN etc.
  Future<bool> authenticate(String? localizedReason) async {
    final bool canAuthenticate =
        await _localAuth.canCheckBiometrics
          || await _localAuth.isDeviceSupported();

    if (!canAuthenticate) {
      return false;
    }

    return await _localAuth.authenticate(
      localizedReason:
        localizedReason
          ?? 'Authenticate to manage the account password',
        options: const AuthenticationOptions(useErrorDialogs: false),
    );
  }
  
  // Whether the device has any security protection enrolled.
  Future<bool> canAuthenticate() async {
    if (Platform.isLinux) {
      return false;
    }

    if (_isApplePlatform) {
      return await DeviceSecurityAuthPlatform.instance.canAuthenticate();
    } else {
      final bool canAuthenticate =
          await _localAuth.canCheckBiometrics
            || await _localAuth.isDeviceSupported();
      return canAuthenticate;
    }
  }

  // Attempt to determine the security type of a device.
  Future<DeviceSecurityType> getDeviceSecurityType() async {
    if (_isApplePlatform) {
      return await DeviceSecurityAuthPlatform.instance.getDeviceSecurityType();
    } else {
      if (await _localAuth.canCheckBiometrics) {
        return DeviceSecurityType.biometric;
      } else if (await _localAuth.isDeviceSupported()) {
        return DeviceSecurityType.pin;
      }
      return DeviceSecurityType.unsupported;
    }
  }
  
  // Create or update a password.
  Future<bool> upsertAccountPassword({
    required String accountName,
    required String password,
    String? localizedReason,
  }) async {
    if (_isApplePlatform) {
      return await DeviceSecurityAuthPlatform.instance
          .upsertAccountPassword(
            serviceName: serviceName,
            accountName: accountName,
            password: password,
      );
    } else {
      final value = await _secureStorage.read(key: accountName);
      if (value == null) {
        return await createAccountPassword(
          accountName: accountName,
          password: password,
          localizedReason: localizedReason,
        );
      } else {
        return await updateAccountPassword(
          accountName: accountName,
          password: password,
          localizedReason: localizedReason,
        );
      }
    }
  }

  // Create a password, this may error if the accountName and 
  // password already exist.
  Future<bool> createAccountPassword({
    required String accountName,
    required String password,
    String? localizedReason,
  }) async {
    if (_isApplePlatform) {
      return await DeviceSecurityAuthPlatform.instance
          .createAccountPassword(
            serviceName: serviceName,
            accountName: accountName,
            password: password,
      );
    } else {
      await _secureStorage.write(
        key: accountName, value: password);
      return true;
    }
  }
  
  // Update an existing password; the accountName and password
  // should already exist.
  Future<bool> updateAccountPassword({
    required String accountName,
    required String password,
    String? localizedReason,
  }) async {
    if (_isApplePlatform) {
      return await DeviceSecurityAuthPlatform.instance
          .updateAccountPassword(
            serviceName: serviceName,
            accountName: accountName,
            password: password,
      );
    } else {
      final authorized = await authenticate(localizedReason);
      if (authorized) {
        await _secureStorage.write(
          key: accountName, value: password);
        return true;
      } else {
        return false;
      }
    }
  }
  
  // Read the account password.
  Future<String?> readAccountPassword({
    required String accountName,
    String? localizedReason,
  }) async {
    if (_isApplePlatform) {
      return await DeviceSecurityAuthPlatform.instance
          .readAccountPassword(
            serviceName: serviceName,
            accountName: accountName,
      );
    } else {
      final authorized = await authenticate(localizedReason);
      if (authorized) {
        return await _secureStorage.read(key: accountName);
      } else {
        return null;
      }
    }
  }
  
  // Delete the account password.
  Future<bool> deleteAccountPassword({
    required String accountName,
    String? localizedReason,
  }) async {
    if (_isApplePlatform) {
      return await DeviceSecurityAuthPlatform.instance
          .deleteAccountPassword(
            serviceName: serviceName,
            accountName: accountName,
      );
    } else {
      final authorized = await authenticate(localizedReason);
      if (authorized) {
        await _secureStorage.delete(key: accountName);
        return true;
      } else {
        return false;
      }
    }
  }
}
