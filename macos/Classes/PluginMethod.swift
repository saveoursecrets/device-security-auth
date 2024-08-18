//
//  PluginMethod.swift

import FlutterMacOS
import Foundation

enum PluginMethod {
    case canAuthenticate
    case upsertAccountPassword(account: WriteAccountPassword)
    case createAccountPassword(account: WriteAccountPassword)
    case readAccountPassword(account: ReadAccountPassword)
    case updateAccountPassword(account: WriteAccountPassword)
    case deleteAccountPassword(account: ReadAccountPassword)
    case getDeviceSecurityType

    static func from(_ call: FlutterMethodCall) -> PluginMethod? {
        switch call.method {
        case "canAuthenticate": return .canAuthenticate
        case "upsertAccountPassword":
            if 
                let arguments = call.arguments as? [String: Any],
                let serviceName : String = arguments["serviceName"] as? String,
                let accountName : String = arguments["accountName"] as? String,
                let password : String = arguments["password"] as? String {
                return .upsertAccountPassword(
                    account: WriteAccountPassword(
                        serviceName: serviceName,
                        accountName: accountName,
                        password: password
                    )
                )
            } else {
                return nil
            }
        case "createAccountPassword":
            if 
                let arguments = call.arguments as? [String: Any],
                let serviceName : String = arguments["serviceName"] as? String,
                let accountName : String = arguments["accountName"] as? String,
                let password : String = arguments["password"] as? String {
                return .createAccountPassword(
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
        case "updateAccountPassword":
            if 
                let arguments = call.arguments as? [String: Any],
                let serviceName : String = arguments["serviceName"] as? String,
                let accountName : String = arguments["accountName"] as? String,
                let password : String = arguments["password"] as? String {
                return .updateAccountPassword(
                    account: WriteAccountPassword(
                        serviceName: serviceName,
                        accountName: accountName,
                        password: password
                    )
                )
            } else {
                return nil
            }
        case "deleteAccountPassword":
            if 
                let arguments = call.arguments as? [String: Any],
                let serviceName : String = arguments["serviceName"] as? String,
                let accountName : String = arguments["accountName"] as? String {
                return .deleteAccountPassword(
                    account: ReadAccountPassword(
                        serviceName: serviceName,
                        accountName: accountName
                    )
                )
            } else {
                return nil
            }
        case "getDeviceSecurityType": return .getDeviceSecurityType
        default:
            return nil
        }
    }
}
