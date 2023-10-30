//
//  PluginMethod.swift

import FlutterMacOS
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
    case createAccountPassword(account: WriteAccountPassword)
    case readAccountPassword(account: ReadAccountPassword)
    case updateAccountPassword(account: WriteAccountPassword)
    case deleteAccountPassword(account: ReadAccountPassword)

    static func from(_ call: FlutterMethodCall) -> PluginMethod? {
        switch call.method {
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
        default:
            return nil
        }
    }
}
