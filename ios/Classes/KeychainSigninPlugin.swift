//
//  KeychainSigninPlugin.swift

import Flutter
import Foundation
import LocalAuthentication

/// Plugin to sign in using the Security and LocalAuthentication frameworks.
public class KeychainSigninPlugin: NSObject, FlutterPlugin {

    let context = LAContext()
    var authPolicy = LAPolicy.deviceOwnerAuthenticationWithBiometrics;
    var localizationModel = LocalizationModel.default

    /// Registers the plugin with the Flutter engine.
    ///
    /// - Parameters:
    ///   - registrar: The Flutter plugin registrar.
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "keychain_signin", binaryMessenger: registrar.messenger())
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
        case .canAuthenticate:
            let (supports, error) = canAuthenticate(with: authPolicy)
            result(supports && error == nil)
        case .authenticate:
            authenticate(with: authPolicy) { authenticated, error in
                if let error = error {
                    let flutterError = FlutterError(
                        code: "authentication_error",
                        message: error.localizedDescription, details: nil)
                    result(flutterError)
                    return
                }
                result(authenticated)
            }
        case .setLocalizationModel(let model):
            if let model {
                localizationModel = model
            }
        case .setBiometricsRequired(let biometricsRequired):
            setBiometricsRequired(biometricsRequired)
        }
    }

    /// Checks if biometric authentication is supported on the device.
    ///
    /// - Parameters:
    ///   - policy: The authentication policy to check.
    /// - Returns: A tuple containing a boolean indicating support and an optional error.
    fileprivate func canAuthenticate(with policy: LAPolicy) -> (Bool, Error?) {
        var error: NSError?
        let supportsAuth = context.canEvaluatePolicy(policy, error: &error)
        return (supportsAuth, error)
    }

    /// Performs biometric authentication with a given policy.
    ///
    /// - Parameters:
    ///   - policy: The authentication policy to use.
    ///   - callback: A callback to handle the authentication result.
    fileprivate func authenticate(with policy: LAPolicy, callback: @escaping (Bool, Error?) -> Void) {
        context.evaluatePolicy(
            policy,
            localizedReason: localizationModel.reason,
            reply: callback,
        )
    }

    fileprivate func setBiometricsRequired(_ biometricsRequired: Bool) {
        if biometricsRequired {
            authPolicy = LAPolicy.deviceOwnerAuthenticationWithBiometrics
        } else {
            authPolicy = LAPolicy.deviceOwnerAuthentication
        }
    }
}
