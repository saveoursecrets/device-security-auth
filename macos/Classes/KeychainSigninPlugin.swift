//
//  KeychainSigninPlugin.swift

import Cocoa
import FlutterMacOS
import LocalAuthentication
import Security

/// A Flutter plugin for local biometric authentication on macOS.
///
/// This plugin provides methods to check for biometric authentication support,
/// perform biometric authentication, and manage Touch ID authentication settings.
public class KeychainSigninPlugin: NSObject, FlutterPlugin {

    let context = LAContext()
    var localizationModel = LocalizationModel.default

    /// Registers the plugin with the Flutter engine.
    ///
    /// - Parameters:
    ///   - registrar: The Flutter plugin registrar.
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "keychain_signin", binaryMessenger: registrar.messenger)
        let instance = KeychainSigninPlugin()
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
        switch method {
            case .saveAccountPassword(let account):
                let keychainQuery: [String: Any] = [
                    kSecClass as String: kSecClassInternetPassword,
                    kSecAttrService as String: account.serviceName,
                    kSecAttrAccount as String: account.accountName,
                    kSecValueData as String: account.password
                ];

                let status = SecItemAdd(keychainQuery as CFDictionary, nil)
                if status == errSecSuccess {
                    result(true)
                } else {
                    let flutterError = FlutterError(
                        code: "save_account_password_error",
                        message: "Error saving password to keychain: \(status)",
                        details: nil)
                    result(flutterError)
                }
            case .readAccountPassword(let account):
                let context = LAContext()
                var error: NSError?

                if context.canEvaluatePolicy(
                    .deviceOwnerAuthentication,
                    error: &error
                ) {
                    authenticate(context) { authenticated, error in
                        if let error = error as? LAError {
                            if error.code == .userCancel {
                                result(nil); 
                            } else {
                                let flutterError = FlutterError(
                                    code: "authentication_error",
                                    message: error.localizedDescription, 
                                    details: nil)
                                result(flutterError)
                            }
                            return
                        } else if let error = error {
                            let flutterError = FlutterError(
                                code: "unknown_authentication_error",
                                message: error.localizedDescription,
                                details: nil)
                            result(flutterError)
                            return
                        }
                        if (authenticated) {
                            let query: [String: Any] = [
                                kSecClass as String: kSecClassInternetPassword,
                                kSecAttrService as String: account.serviceName,
                                kSecAttrAccount as String: account.accountName,
                                kSecReturnData as String: kCFBooleanTrue,
                                kSecMatchLimit as String: kSecMatchLimitOne
                            ];
                            
                            var passwordData: AnyObject?
                            let status = SecItemCopyMatching(
                                query as CFDictionary, &passwordData)
                            if status == errSecSuccess, 
                                let retrievedData = passwordData as? Data,
                                let retrievedPassword = String(
                                    data: retrievedData, encoding: .utf8) {
                                result(retrievedPassword)
                            }
                        } else {
                            result(nil)
                        }
                    }
                } else {
                    if let error = error {
                        let flutterError = FlutterError(
                            code: "can_evaluate_policy_error",
                            message: error.localizedDescription,
                            details: nil)
                        result(flutterError)
                    } else {
                        let flutterError = FlutterError(
                            code: "can_evaluate_policy_error",
                            message: "device authentication is not available",
                            details: nil)
                        result(flutterError)
                    }
                }
            case .setLocalizationModel(let model):
                if let model {
                    localizationModel = model
                }
        }
    }

    /// Performs device authentication.
    fileprivate func authenticate(_ context: LAContext, callback: @escaping (Bool, Error?) -> Void) {
        context.evaluatePolicy(
            LAPolicy.deviceOwnerAuthentication,
            localizedReason: localizationModel.reason, reply: callback)
    }
}
