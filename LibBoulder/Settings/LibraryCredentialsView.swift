//
//  LibraryCredentialsView.swift
//  LibBoulder
//
//  Created by Collin Palmer on 8/22/24.
//

import SwiftUI

struct LibraryCredentialsView: View {
    @Environment(\.libCatAPI) var libCatAPI
    @Environment(\.keychain) var keychain
    @StateObject var viewModel: LibraryCredentialsViewModel = LibraryCredentialsViewModel()
    @State private var cardNumberVisible = false
    @FocusState private var cardNumberFocused: Bool
    // TODO: Should query DB initially to determine this.
    let library: LibraryId
    
    var authenticateButtonString: String {
        (viewModel.authenticated) ? "Deauthenticate" : "Authenticate"
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(library.name)
                .font(.title2)
            VStack {
                TextField(text: $viewModel.username, prompt: Text("Card number")) {
                    Text("Card number")
                }
                .monospaced()
                .keyboardType(.numberPad)
                .focused($cardNumberFocused)
                .onSubmit {
                    Task {
                        await viewModel.authenticateCard()
                    }
                }

                if library.requiresPassword {
                    SecureField(text: $viewModel.password, prompt: Text("Password")) {
                        Text("Password")
                    }
                }
            }
            .padding(.bottom, 16)
            
            Button {
                cardNumberFocused = false
                Task {
                    await viewModel.authenticateCard()
                }
            } label: {
                if viewModel.authenticationInProgress {
                    HStack {
                        Text(authenticateButtonString)
                        ProgressView()
                    }
                } else {
                    Text(authenticateButtonString)
                }
            }
            .foregroundStyle(viewModel.authenticated ? .red : .blue)
            .buttonStyle(.bordered)
            .disabled(viewModel.authenticationInProgress)
        }
        .onAppear {
            viewModel.library = library
            viewModel.keychain = keychain
            viewModel.username = (try? keychain.get(key: library.keychainUsernameKey)) ?? ""
            // TODO: Add to VM and test
            if let passwordKey = library.keychainPasswordKey {
                viewModel.password = (try? keychain.get(key: passwordKey)) ?? ""
                // TODO: Consider a different approach?
                viewModel.authenticated = ((viewModel.username.isEmpty == false) && (viewModel.password.isEmpty == false))
            } else {
                viewModel.authenticated = (viewModel.username.isEmpty == false)
            }
        }
    }
}

#Preview {
    LibraryCredentialsView(library: .norlin)
}
