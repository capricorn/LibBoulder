//
//  KeychainAccessExtensions.swift
//  LibBoulder
//
//  Created by Collin Palmer on 8/22/24.
//

import Foundation
import KeychainAccess

enum KeychainAccessKey: String {
    case norlinUsername
}

extension Keychain {
    func get(key: KeychainAccessKey) throws -> String? {
        try self.get(key.rawValue)
    }
    
    func set(key: KeychainAccessKey, _ value: String) throws {
        try self.set(value, key: key.rawValue)
    }
    
    func remove(key: KeychainAccessKey) throws {
        try self.remove(key.rawValue)
    }
}

extension Keychain: KeychainRepresentable {}
