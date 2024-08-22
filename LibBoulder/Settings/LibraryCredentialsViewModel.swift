//
//  LibraryCredentialsViewModel.swift
//  LibBoulder
//
//  Created by Collin Palmer on 8/22/24.
//

import SwiftUI

@MainActor
class LibraryCredentialsViewModel: ObservableObject {
    @Published var cardNumber: String = ""
    @Published var authenticationInProgress = false
    @Published var authenticated: Bool = false

    var libCatAPI: LibCatAPIRepresentable!
    
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
            authenticated = false
            cardNumber = ""
        } else {
            if await authenticate() {
                // TODO: Authenticate here
                authenticated = true
            }
        }
    }
    
    func storeCredentials() {
        // TODO: Store library credentials in keychain
        // (Require library identifier..?)
    }
}
