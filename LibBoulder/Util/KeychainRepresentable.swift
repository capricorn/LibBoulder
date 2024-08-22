//
//  KeychainRepresentable.swift
//  LibBoulder
//
//  Created by Collin Palmer on 8/22/24.
//

import Foundation

protocol KeychainRepresentable {
    func get(key: KeychainAccessKey) throws -> String?
    func set(key: KeychainAccessKey, _ value: String) throws
    func remove(key: KeychainAccessKey) throws
}
