//
//  KeychainSigninPlugin.swift

import Cocoa
import FlutterMacOS
import Security

/// A Flutter plugin to use the keychain for sign.
public class KeychainSigninPlugin: NSObject, FlutterPlugin {

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
                var accessControlError: Unmanaged<CFError>?
                defer {
                    accessControlError?.release()
                }

                guard let accessControl = SecAccessControlCreateWithFlags(
                    nil,
                    kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly as CFString,
                    [.userPresence],
                    &accessControlError
                ) else {
                    if let error = accessControlError {
                        let flutterError = FlutterError(
                            code: "access_control_error",
                            message: "access control error: \(error)",
                            details: nil)
                        result(flutterError)
                    }
                    return
                }
                
                var keychainQuery = [
                    kSecAttrAccessControl: accessControl,
                    kSecClass: kSecClassGenericPassword,
                    kSecAttrService: account.serviceName,
                    kSecAttrAccount: account.accountName,
                    kSecValueData: account.password.data(using: .utf8)!
                ] as [String: Any];

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
                let query: [String: Any] = [
                    kSecClass as String: kSecClassGenericPassword,
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
                } else {
                    let flutterError = FlutterError(
                        code: "read_account_password_error",
                        message: "error reading password from keychain: \(status)",
                        details: nil)
                    result(flutterError)
                }
            case .setLocalizationModel(let model):
                if let model {
                    localizationModel = model
                }
        }
    }
}
