//
//  LibraryCredentialsView.swift
//  LibBoulder
//
//  Created by Collin Palmer on 8/22/24.
//

import SwiftUI

struct LibraryCredentialsView: View {
    @Environment(\.libCatAPI) var libCatAPI
    @StateObject var viewModel: LibraryCredentialsViewModel = LibraryCredentialsViewModel()
    @State private var password: String = ""
    @State private var cardNumberVisible = false
    // TODO: Should query DB initially to determine this.
    
    let libraryName: String
    let requiresPassword: Bool
    
    var authenticateButtonString: String {
        (viewModel.authenticated) ? "Deauthenticate" : "Authenticate"
    }
    
    init(name libraryName: String, requiresPassword: Bool = false) {
        self.libraryName = libraryName
        self.requiresPassword = requiresPassword
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(libraryName)
                .font(.title2)
            VStack {
                TextField(text: $viewModel.cardNumber, prompt: Text("Card number")) {
                    Text("Card number")
                }
                .monospaced()
                .keyboardType(.numberPad)
                
                if requiresPassword {
                    SecureField(text: $password, prompt: Text("Password")) {
                        Text("Password")
                    }
                }
            }
            .padding(.bottom, 16)
            
            Button {
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
            .buttonStyle(.bordered)
            .disabled(viewModel.authenticationInProgress)
        }
        .onAppear{
            viewModel.libCatAPI = libCatAPI
        }
    }
}

#Preview {
    LibraryCredentialsView(
        name: "Norlin Library"
    )
}
