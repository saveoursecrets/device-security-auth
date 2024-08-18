import Foundation
import FlutterMacOS
import Security
import LocalAuthentication

/// A Flutter plugin to use the keychain for sign.
public class DeviceSecurityAuthPlugin: NSObject, FlutterPlugin {
    let context = LAContext()

    /// Registers the plugin with the Flutter engine.
    ///
    /// - Parameters:
    ///   - registrar: The Flutter plugin registrar.
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "device_security_auth", binaryMessenger: registrar.messenger)
        let instance = DeviceSecurityAuthPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    /// Handles method calls from Flutter.
    ///
    /// - Parameters:
    ///   - call: The method call received from Flutter.
    ///   - result: The result callback to send the response back to Flutter.
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let method = PluginMethod.from(call) else {
            return result(FlutterMethodNotImplemented)
        }
        let access = LocalKeychainAccess()
        switch method {
            case .canAuthenticate:
                let (supports, error) = supportsLocalAuthentication(
                    with: .deviceOwnerAuthentication)
                result(supports && error == nil)
            case .upsertAccountPassword(let account):
                do {
                    let status = try access.upsertAccountPassword(account: account)
                    if status == errSecSuccess || status == errSecUserCanceled {
                        result(status == errSecSuccess)
                    } else {
                        let flutterError = FlutterError(
                            code: "upsert_password_error",
                            message: "error upserting password: \(status)",
                            details: nil)
                        result(flutterError)
                    }
                } catch {
                    let flutterError = FlutterError(
                        code: "upsert_password_error",
                        message: "error upserting password: \(error)",
                        details: nil)
                    result(flutterError)
                }
            case .createAccountPassword(let account):
                do {
                    let status = try access.createAccountPassword(account: account)
                    if status == errSecSuccess || status == errSecUserCanceled {
                        result(status == errSecSuccess)
                    } else {
                        let flutterError = FlutterError(
                            code: "create_password_error",
                            message: "error creating password: \(status)",
                            details: nil)
                        result(flutterError)
                    }
                } catch {
                    let flutterError = FlutterError(
                        code: "create_password_error",
                        message: "error creating password: \(error)",
                        details: nil)
                    result(flutterError)
                }
            case .readAccountPassword(let account):
                let (status, retrievedPassword) = access.readAccountPassword(account: account)
                if status == errSecSuccess {
                    result(retrievedPassword)
                } else if(
                    status == errSecItemNotFound
                        || status == errSecUserCanceled) {
                    result(nil)
                } else {
                    let flutterError = FlutterError(
                        code: "read_password_error",
                        message: "error reading password: \(status)",
                        details: nil)
                    result(flutterError)
                }
            case .updateAccountPassword(let account):
                let status = access.updateAccountPassword(account: account)
                if status == errSecSuccess || status == errSecUserCanceled {
                    result(status == errSecSuccess)
                } else {
                    let flutterError = FlutterError(
                        code: "update_password_error",
                        message: "error updating password: \(status)",
                        details: nil)
                    result(flutterError)
                }
            case .deleteAccountPassword(let account):
                let status = access.deleteAccountPassword(account: account)
                if status == errSecSuccess || status == errSecItemNotFound {
                    result(status == errSecSuccess)
                } else {
                    let flutterError = FlutterError(
                        code: "delete_password_error",
                        message: "error deleting password: \(status)",
                        details: nil)
                    result(flutterError)
                }
            case .getDeviceSecurityType:
                return result(getDeviceSecurityType());
        }
    }

    /// Checks if biometric authentication is supported on the device.
    ///
    /// - Parameters:
    ///   - policy: The authentication policy to check.
    /// - Returns: A tuple containing a boolean indicating support and an optional error.
    fileprivate func supportsLocalAuthentication(with policy: LAPolicy) -> (Bool, Error?) {
        var error: NSError?
        let supportsAuth = context.canEvaluatePolicy(policy, error: &error)
        return (supportsAuth, error)
    }

    fileprivate func getDeviceSecurityType() -> String {
        var error: NSError?

        // Check if biometric authentication is available
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            if #available(macOS 10.15, *) {
                // macOS 10.15 and later support evaluating for multiple biometric types
                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                    if context.biometryType == .faceID {
                        return "face"
                    } else if context.biometryType == .touchID {
                        return "touch"
                    } else {
                        return "biometric"
                    }
                }
            } else {
                // On earlier macOS versions, you can only check for Touch ID
                if context.canEvaluatePolicy(
                    .deviceOwnerAuthenticationWithBiometrics, error: &error) {
                    return "touch"
                }
            }

            // If no biometric is available, the user is 
            // likely using a passcode
            return "passcode"
        } else {
            // Device security is not enrolled
            return "none"
        }
    }
}
