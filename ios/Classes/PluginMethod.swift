//
//  PluginMethod.swift

import Flutter
import Foundation

struct ReadAccountPassword {
    var serviceName: String
    var accountName: String
}

struct WriteAccountPassword {
    var serviceName: String
    var accountName: String
    var password: String
}

enum PluginMethod {
    case saveAccountPassword(account: WriteAccountPassword)
    case readAccountPassword(account: ReadAccountPassword)
    case setLocalizationModel(model: LocalizationModel?)

    static func from(_ call: FlutterMethodCall) -> PluginMethod? {
        switch call.method {
        case "saveAccountPassword":
            if 
                let arguments = call.arguments as? [String: Any],
                let serviceName : String = arguments["serviceName"] as? String,
                let accountName : String = arguments["accountName"] as? String,
                let password : String = arguments["password"] as? String {
                return .saveAccountPassword(
                    account: WriteAccountPassword(
                        serviceName: serviceName,
                        accountName: accountName,
                        password: password
                    )
                )
            } else {
                return nil
            }
        case "readAccountPassword":
            if 
                let arguments = call.arguments as? [String: Any],
                let serviceName : String = arguments["serviceName"] as? String,
                let accountName : String = arguments["accountName"] as? String {
                return .readAccountPassword(
                    account: ReadAccountPassword(
                        serviceName: serviceName,
                        accountName: accountName
                    )
                )
            } else {
                return nil
            }
        case "setLocalizationModel":
            let model = LocalizationModel.from(call.arguments as? [String: Any])
            return .setLocalizationModel(model: model)
        default:
            return nil
        }
    }
}
