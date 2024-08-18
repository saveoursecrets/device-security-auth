import 'package:flutter/services.dart';

import 'keychain_signin_platform_interface.dart';

/// An implementation of [KeychainSigninPlatform] that uses method channels.
class MethodChannelKeychainSignin extends KeychainSigninPlatform {
  final methodChannel = const MethodChannel('keychain_signin');

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
}
