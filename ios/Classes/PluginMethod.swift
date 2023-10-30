//
//  PluginMethod.swift

import Flutter
import Foundation

enum PluginMethod {
    case canAuthenticate
    case authenticate
    case setLocalizationModel(model: LocalizationModel?)
    case setBiometricsRequired(biometricsRequired: Bool)

    static func from(_ call: FlutterMethodCall) -> PluginMethod? {
        switch call.method {
        case "canAuthenticate": return .canAuthenticate
        case "authenticate": return .authenticate
        case "setLocalizationModel":
            let model = LocalizationModel.from(call.arguments as? [String: Any])
            return .setLocalizationModel(model: model)
        case "setBiometricsRequired":
            if 
                let arguments = call.arguments as? [String: Any],
                let biometricsRequired : Bool = arguments["biometricsRequired"] as? Bool {
                return .setBiometricsRequired(biometricsRequired: biometricsRequired)
            } else {
                return nil
            }
        default:
            return nil
        }
    }
}
