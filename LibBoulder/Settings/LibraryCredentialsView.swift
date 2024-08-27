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
    @State private var password: String = ""
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
                TextField(text: $viewModel.cardNumber, prompt: Text("Card number")) {
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
                    SecureField(text: $password, prompt: Text("Password")) {
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
        .onAppear{
            viewModel.libCatAPI = libCatAPI
            viewModel.keychain = keychain
            viewModel.cardNumber = (try? keychain.get(key: .norlinUsername)) ?? ""
            viewModel.authenticated = ((try? keychain.get(key: .norlinUsername)) != nil)
        }
    }
}

#Preview {
    LibraryCredentialsView(library: .norlin)
}
