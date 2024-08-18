import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'device_security_type.dart';
import 'device_security_auth_method_channel.dart';

/// An abstract platform interface for the Keychain Signin plugin.
///
/// This platform interface defines the methods that must be implemented by
/// platform-specific classes to provide biometric authentication functionality.
abstract class DeviceSecurityAuthPlatform extends PlatformInterface {
  DeviceSecurityAuthPlatform() : super(token: _token);

  static final Object _token = Object();

  static DeviceSecurityAuthPlatform _instance =
      MethodChannelDeviceSecurityAuth();

  /// The default instance of [DeviceSecurityAuthPlatform] to use.
  ///
  /// Defaults to [MethodChannelDeviceSecurityAuth].
  static DeviceSecurityAuthPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DeviceSecurityAuthPlatform] when
  /// they register themselves.
  static set instance(DeviceSecurityAuthPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Checks whether biometric authentication is available on the device.
  ///
  /// Returns `true` if biometric authentication is available, `false` otherwise.
  Future<bool> canAuthenticate() {
    throw UnimplementedError('canAuthenticate() has not been implemented.');
  }

  /// Upsert an account password.
  Future<bool> upsertAccountPassword({
    required String serviceName,
    required String accountName,
    required String password,
  }) async {
    throw UnimplementedError('upsertAccountPassword() has not been implemented.');
  }
  
  /// Create an account password.
  Future<bool> createAccountPassword({
    required String serviceName,
    required String accountName,
    required String password,
  }) async {
    throw UnimplementedError('createAccountPassword() has not been implemented.');
  }

  /// Update an account password.
  Future<bool> updateAccountPassword({
    required String serviceName,
    required String accountName,
    required String password,
  }) async {
    throw UnimplementedError('updateAccountPassword() has not been implemented.');
  }

  /// Read an account password.
  Future<String?> readAccountPassword({
    required String serviceName,
    required String accountName,
  }) async {
    throw UnimplementedError('readAccountPassword() has not been implemented.');
  }

  /// Delete an account password.
  Future<bool> deleteAccountPassword({
    required String serviceName,
    required String accountName,
  }) async {
    throw UnimplementedError('deleteAccountPassword() has not been implemented.');
  }
  // Attempt to determine the security type of a device.
  Future<DeviceSecurityType> getDeviceSecurityType() async {
    throw UnimplementedError(
        'getDeviceSecurityType() has not been implemented.');
  }
}
