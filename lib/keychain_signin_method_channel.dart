import 'dart:io';
import 'package:flutter/services.dart';
import 'keychain_signin_platform_interface.dart';
import 'device_security_type.dart';

/// An implementation of [KeychainSigninPlatform] that uses method channels.
class MethodChannelKeychainSignin extends KeychainSigninPlatform {
  final methodChannel = const MethodChannel('keychain_signin');

  @override
  Future<bool> upsertAccountPassword({
    required String serviceName,
    required String accountName,
    required String password,
  }) async {
    return await methodChannel.invokeMethod(
      'upsertAccountPassword',
      {
        'serviceName': serviceName,
        'accountName': accountName,
        'password': password,
      },
    );
  }

  @override
  Future<bool> createAccountPassword({
    required String serviceName,
    required String accountName,
    required String password,
  }) async {
    return await methodChannel.invokeMethod(
      'createAccountPassword',
      {
        'serviceName': serviceName,
        'accountName': accountName,
        'password': password,
      },
    );
  }

  @override
  Future<bool> updateAccountPassword({
    required String serviceName,
    required String accountName,
    required String password,
  }) async {
    return await methodChannel.invokeMethod(
      'updateAccountPassword',
      {
        'serviceName': serviceName,
        'accountName': accountName,
        'password': password,
      },
    );
  }

  @override
  Future<String?> readAccountPassword({
    required String serviceName,
    required String accountName,
  }) async {
    return await methodChannel.invokeMethod(
      'readAccountPassword',
      {
        'serviceName': serviceName,
        'accountName': accountName,
      },
    );
  }
  
  @override
  Future<bool> deleteAccountPassword({
    required String serviceName,
    required String accountName,
  }) async {
    return await methodChannel.invokeMethod(
      'deleteAccountPassword',
      {
        'serviceName': serviceName,
        'accountName': accountName,
      },
    );
  }
  @override
  Future<DeviceSecurityType> getDeviceSecurityType() async {
    if (Platform.isMacOS || Platform.isIOS || Platform.isAndroid) {
      final String result = await methodChannel.invokeMethod('getDeviceSecurityType');
      return DeviceSecurityType.values.firstWhere(
        (item) => item.toString() == 'DeviceSecurityType.$result');
    } else {
      return DeviceSecurityType.unsupported;
    }
  }
}
