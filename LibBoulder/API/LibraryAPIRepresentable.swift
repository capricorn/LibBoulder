//
//  LibraryAPIRepresentable.swift
//  LibBoulder
//
//  Created by Collin Palmer on 8/27/24.
//

import Foundation

enum LibraryId: String, CaseIterable, Identifiable {
    case norlin
    case boulder
    
    var name: String {
        switch self {
        case .norlin:
            "Norlin Library"
        case .boulder:
            "Boulder Public Library"
        }
    }
    
    var requiresPassword: Bool {
        switch self {
        case .norlin:
            false
        case .boulder:
            true
        }
    }
    
    var id: Self {
        self
    }
    
    var api: any LibraryAPIRepresentable {
        switch self {
        case .norlin:
            LibCatAPI()
        case .boulder:
            BoulderPublicLibraryAPI()
        }
    }
    
    // TODO: Consider a different approach to pairing; for now, separate
    var keychainUsernameKey: KeychainAccessKey {
        switch self {
        case .norlin:
            .norlinUsername
        case .boulder:
            .boulderUsername
        }
    }
    
    var keychainPasswordKey: KeychainAccessKey? {
        switch self {
        case .norlin:
            nil
        case .boulder:
            .boulderPassword
        }
    }
    
    func authenticated(keychain: KeychainRepresentable) -> Bool {
        if (try? keychain.get(key: self.keychainUsernameKey)) == nil {
            return false
        }
        
        if let keychainPasswordKey = self.keychainPasswordKey,
           (try? keychain.get(key: keychainPasswordKey)) == nil {
            return false
        }
        
        return true
    }
}

protocol LibraryAPIRepresentable: Identifiable {
    var id: LibraryId { get }
    func login(username: String, password: String) async throws
    func fetchCheckedOutBooks() async throws -> CheckedOutBooksModel
}
