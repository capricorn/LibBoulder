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
    @Published var cardNumber: String = ""
    @Published var authenticationInProgress = false
    @Published var authenticated: Bool = false

    var libCatAPI: LibCatAPIRepresentable!
    var keychain: Keychain!
    
    func authenticate() async -> Bool {
        await MainActor.run {
            authenticationInProgress = true
        }
        
        var success = false
        do {
            // TODO: Handle password
            try await libCatAPI.login(cardNumber: cardNumber)
            success = true
        } catch {}
        
        await MainActor.run {
            authenticationInProgress = false
        }
        
        return success
    }
    
    func authenticateCard() async {
        if authenticated {
            cardNumber = ""
            do {
                try keychain.remove(key: .norlinUsername)
                authenticated = false
            } catch {
                print("Failed to remove keychain: \(error)")
            }
        } else {
            if await authenticate() {
                // TODO: Authenticate here
                do {
                    authenticated = true
                    try keychain.set(key: .norlinUsername, cardNumber)
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
