//
//  PluginMethod.swift

import FlutterMacOS
import Foundation

enum PluginMethod {
    case canAuthenticate
    case authenticate(allowReuse: Bool)
    case setLocalizationModel(model: LocalizationModel?)

    static func from(_ call: FlutterMethodCall) -> PluginMethod? {
        switch call.method {
        case "canAuthenticate": return .canAuthenticate
        case "authenticate":
            if 
                let arguments = call.arguments as? [String: Any],
                let allowReuse : Bool = arguments["allowReuse"] as? Bool {
                return .authenticate(allowReuse: allowReuse)
            } else {
                return .authenticate(allowReuse: false)
            }
        case "setLocalizationModel":
            let model = LocalizationModel.from(call.arguments as? [String: Any])
            return .setLocalizationModel(model: model)
        default:
            return nil
        }
    }
}
