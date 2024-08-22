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
}
