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
    func delete(service: String, account: String) {
        let query = [
            kSecAttrService: service as AnyObject,
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account as AnyObject
        ] as CFDictionary
        SecItemDelete(query)
    }
    func isDuplicateEmail(service: String, account: String) -> Bool {
        let query: [String: AnyObject] = [
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecClass as String: kSecClassGenericPassword
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecDuplicateItem
    }
}
