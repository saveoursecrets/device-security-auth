import 'keychain_signin_platform_interface.dart';

/// Plugin for  authentication using the Security and 
/// LocalAuthentication frameworks.
class KeychainSignin {

  Future<bool> upsertAccountPassword({
    required String serviceName,
    required String accountName,
    required String password,
  }) async {
    return await KeychainSigninPlatform.instance
        .upsertAccountPassword(
          serviceName: serviceName,
          accountName: accountName,
          password: password,
    );
  }

  Future<bool> createAccountPassword({
    required String serviceName,
    required String accountName,
    required String password,
  }) async {
    return await KeychainSigninPlatform.instance
        .createAccountPassword(
          serviceName: serviceName,
          accountName: accountName,
          password: password,
    );
  }

  Future<bool> updateAccountPassword({
    required String serviceName,
    required String accountName,
    required String password,
  }) async {
    return await KeychainSigninPlatform.instance
        .updateAccountPassword(
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

  Future<bool> deleteAccountPassword({
    required String serviceName,
    required String accountName,
  }) async {
    return await KeychainSigninPlatform.instance
        .deleteAccountPassword(
          serviceName: serviceName,
          accountName: accountName,
    );
  }
}
