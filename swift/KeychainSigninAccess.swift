import Foundation
import Security

public struct ReadAccountPassword {
    var serviceName: String
    var accountName: String
}

public struct WriteAccountPassword {
    var serviceName: String
    var accountName: String
    var password: String
}

// Simple wrapper for accessing the security framework functions.
public class KeychainSigninAccess {
        
    public init() {}

    public func upsertAccountPassword(account: WriteAccountPassword) throws -> OSStatus {
        let status = updateAccountPassword(account: account)
        if status == errSecItemNotFound {
            return try createAccountPassword(account: account)
        } else {
            return status
        }
    }

    public func createAccountPassword(account: WriteAccountPassword) throws -> OSStatus {
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
            guard let error = accessControlError?.takeRetainedValue() else {
                // Handle the case when CFErrorCreate fails
                throw NSError(domain: NSCocoaErrorDomain, code: NSFeatureUnsupportedError, userInfo: nil)
            }
            throw error as Error
        }
        
        let query = [
            kSecAttrAccessControl: accessControl,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: account.serviceName,
            kSecAttrAccount: account.accountName,
            kSecValueData: account.password.data(using: .utf8)!
        ] as [String: Any];

        let status = SecItemAdd(query as CFDictionary, nil)
        return status
    }
        
    public func readAccountPassword(account: ReadAccountPassword) -> (OSStatus, String?) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: account.serviceName,
            kSecAttrAccount: account.accountName,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as [String: Any];
        
        var passwordData: AnyObject?
        let status = SecItemCopyMatching(
            query as CFDictionary, &passwordData)
        if let retrievedData = passwordData as? Data,
            let retrievedPassword = String(
            data: retrievedData, encoding: .utf8) {

            return (status, retrievedPassword)
        } else {
            return (status, nil)
        }
    }

    public func updateAccountPassword(account: WriteAccountPassword) -> OSStatus {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: account.serviceName,
            kSecAttrAccount: account.accountName,
        ] as [String: Any];

        let attributes = [
            kSecValueData: account.password.data(
                using: String.Encoding.utf8)!
        ] as [String: Any];
        
        return SecItemUpdate(
            query as CFDictionary,
            attributes as CFDictionary)
    }

    public func deleteAccountPassword(account: ReadAccountPassword) -> OSStatus {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: account.serviceName,
            kSecAttrAccount: account.accountName
        ] as [String: Any];
        
        return SecItemDelete(query as CFDictionary)
    }
}
