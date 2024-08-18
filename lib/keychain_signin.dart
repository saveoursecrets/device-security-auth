import 'dart:io';

import 'keychain_signin_platform_interface.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'device_security_type.dart';
export 'device_security_type.dart';

/// Plugin for authentication using the Security and 
/// LocalAuthentication frameworks.
class KeychainSignin {
  // Local device authentication.
  final LocalAuthentication localAuth = LocalAuthentication();
  
  // Secure storage.
  final secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true));
  
  // Apple platform uses the Keychain backed by biometric unlock.
  bool get isApplePlatform => Platform.isMacOS || Platform.isIOS;

  // Whether the platform supports device authentication.
  bool get supportsDeviceAuthentication {
    return isApplePlatform || Platform.isAndroid;
  }
  
  // Authenticate using the device biometrics or PIN etc.
  Future<bool> authenticate(String? localizedReason) async {
    final bool canAuthenticate =
        await localAuth.canCheckBiometrics
          || await localAuth.isDeviceSupported();

    if (!canAuthenticate) {
      return false;
    }

    return await localAuth.authenticate(
      localizedReason:
        localizedReason
          ?? 'Authenticate to manage the account password',
        options: const AuthenticationOptions(useErrorDialogs: false),
    );
  }

  Future<bool> canAuthenticate() async {
    if (Platform.isLinux) {
      return false;
    }

    if (isApplePlatform) {
      return await KeychainSigninPlatform.instance.canAuthenticate();
    } else {
      final bool canAuthenticate =
          await localAuth.canCheckBiometrics
            || await localAuth.isDeviceSupported();
      return canAuthenticate;
    }
  }

  // Attempt to determine the security type of a device.
  Future<DeviceSecurityType> getDeviceSecurityType() async {
    if (isApplePlatform) {
      return await KeychainSigninPlatform.instance.getDeviceSecurityType();
    } else {
      if (await localAuth.canCheckBiometrics) {
        return DeviceSecurityType.biometric;
      } else if (await localAuth.isDeviceSupported()) {
        return DeviceSecurityType.pin;
      }
      return DeviceSecurityType.unsupported;
    }
  }

  Future<bool> upsertAccountPassword({
    required String serviceName,
    required String accountName,
    required String password,
    String? localizedReason,
  }) async {
    if (isApplePlatform) {
      return await KeychainSigninPlatform.instance
          .upsertAccountPassword(
            serviceName: serviceName,
            accountName: accountName,
            password: password,
      );
    } else {
      final value = await secureStorage.read(key: accountName);
      if (value == null) {
        return await createAccountPassword(
          serviceName: serviceName,
          accountName: accountName,
          password: password,
          localizedReason: localizedReason,
        );
      } else {
        return await updateAccountPassword(
          serviceName: serviceName,
          accountName: accountName,
          password: password,
          localizedReason: localizedReason,
        );
      }
    }
  }

  Future<bool> createAccountPassword({
    required String serviceName,
    required String accountName,
    required String password,
    String? localizedReason,
  }) async {
    if (isApplePlatform) {
      return await KeychainSigninPlatform.instance
          .createAccountPassword(
            serviceName: serviceName,
            accountName: accountName,
            password: password,
      );
    } else {
      await secureStorage.write(
        key: accountName, value: password);
      return true;
    }
  }

  Future<bool> updateAccountPassword({
    required String serviceName,
    required String accountName,
    required String password,
    String? localizedReason,
  }) async {
    if (isApplePlatform) {
      return await KeychainSigninPlatform.instance
          .updateAccountPassword(
            serviceName: serviceName,
            accountName: accountName,
            password: password,
      );
    } else {
      final authorized = await authenticate(localizedReason);
      if (authorized) {
        await secureStorage.write(
          key: accountName, value: password);
        return true;
      } else {
        return false;
      }
    }
  }

  Future<String?> readAccountPassword({
    required String serviceName,
    required String accountName,
    String? localizedReason,
  }) async {
    if (isApplePlatform) {
      return await KeychainSigninPlatform.instance
          .readAccountPassword(
            serviceName: serviceName,
            accountName: accountName,
      );
    } else {
      final authorized = await authenticate(localizedReason);
      if (authorized) {
        return await secureStorage.read(key: accountName);
      } else {
        return null;
      }
    }
  }

  Future<bool> deleteAccountPassword({
    required String serviceName,
    required String accountName,
    String? localizedReason,
  }) async {
    if (isApplePlatform) {
      return await KeychainSigninPlatform.instance
          .deleteAccountPassword(
            serviceName: serviceName,
            accountName: accountName,
      );
    } else {
      final authorized = await authenticate(localizedReason);
      if (authorized) {
        await secureStorage.delete(key: accountName);
        return true;
      } else {
        return false;
      }
    }
  }
}
