//
//  LibraryCredentialsViewModel.swift
//  LibBoulder
//
//  Created by Collin Palmer on 8/22/24.
//

import SwiftUI
import KeychainAccess

@MainActor
class LibraryCredentialsViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var authenticationInProgress = false
    @Published var authenticated: Bool = false

    var library: LibraryId!
    var keychain: KeychainRepresentable!
    
    func authenticate() async -> Bool {
        await MainActor.run {
            authenticationInProgress = true
        }
        
        var success = false
        do {
            // TODO: Handle password
            try await library.api.login(username: username, password: password)
            success = true
        } catch {}
        
        await MainActor.run {
            authenticationInProgress = false
        }
        
        return success
    }
    
    func authenticateCard() async {
        if authenticated {
            username = ""
            password = ""
            do {
                try keychain.remove(key: library.keychainUsernameKey)
                if let passwordKey = library.keychainPasswordKey {
                    try keychain.remove(key: passwordKey)
                }
                authenticated = false
            } catch {
                print("Failed to remove keychain: \(error)")
            }
        } else {
            if await authenticate() {
                // TODO: Authenticate here
                do {
                    authenticated = true
                    try keychain.set(key: library.keychainUsernameKey, username)
                    if let passwordKey = library.keychainPasswordKey {
                        try keychain.set(key: passwordKey, password)
                    }
                } catch {
                    print("Failed to set keychain: \(error)")
                }
            }
        }
    }
    
    func storeCredentials() {
        // TODO: Store library credentials in keychain
        // (Require library identifier..?)
    }
}
