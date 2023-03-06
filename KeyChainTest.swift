//
//  KeyChainTest.swift
//  loseamp
//
//  Created by Axente Andrei on 16.02.2023.
//

import Foundation
import SwiftUI


func save(account: String, password: String) {
    
    do {
        try KeychainManager.save(
            service: "loseamp",
            account: account,
            password: password.data(using: .utf8) ?? Data())

    } catch {
        print(error)
    }
}

func getPassword(account: String, password: String) {
    guard let data = KeychainManager.get(
        service: "loseamp",
        account: account
    ) else {
        print("Failed to read password")
        return
    }
    let password = String(decoding: data, as: UTF8.self)
    print("read password here: \(password)")
}



class KeychainManager {
    enum KeychainError: Error {
        case duplicateEntry
        case unknown(OSStatus)
    }
    static func save(service: String, account: String, password: Data) throws {
        // service, account, password, class, data
        let query: [String: AnyObject] = [
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecValueData as String: password as AnyObject,
            kSecClass as String: kSecClassGenericPassword
        ]
        print("Query dictionary: \(query)")
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateEntry
        }
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }
    static func get(service: String, account: String) -> Data? {
        let query: [String: AnyObject] = [
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecClass as String: kSecClassGenericPassword,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        print("Read status: \(status)")
        return result as? Data
        
    }
    func update(service: String, account: String, password: Data) {
        let query = [
            kSecAttrService: service as AnyObject,
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount: account as AnyObject,
        ] as CFDictionary
        
        let updatedData = [kSecValueData: password] as CFDictionary
        SecItemUpdate(query, updatedData)
    }
    func deleteKeychainItem(forService service: String, account: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unknown(status)
        }
    }
    func deleteAllKeychainItems(forService service: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecMatchLimit as String: kSecMatchLimitAll,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        // Check if any items were found
        guard status != errSecItemNotFound else {
            print("Nothing to delete")
            return // no accounts linked with the 'service'
        }
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
        if let items = result as? [[String: Any]] {
            for item in items {
                guard let account = item[kSecAttrAccount as String] as? String else {
                    continue // Skip items without an account attribute
                }
                do {
                    try deleteKeychainItem(forService: service, account: account)
                    print("deleted")
                } catch {
                    // Handle any errors that occur during deletion
                    print("Error deleting keychain item for account \(account): \(error)")
                }
            }
        }
    }

    func isDuplicateEmail(account: String) -> Bool {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account as AnyObject,
        ] as [String: Any]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        return status == errSecSuccess
    }
}
