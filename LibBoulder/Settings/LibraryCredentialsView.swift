//
//  LibraryCredentialsView.swift
//  LibBoulder
//
//  Created by Collin Palmer on 8/22/24.
//

import SwiftUI

struct LibraryCredentialsView: View {
    @Environment(\.libCatAPI) var libCatAPI
    @State private var cardNumber: String = ""
    @State private var password: String = ""
    @State private var cardNumberVisible = false
    // TODO: Should query DB initially to determine this.
    @State private var authenticated = false
    
    let libraryName: String
    let requiresPassword: Bool
    
    init(name libraryName: String, requiresPassword: Bool = false) {
        self.libraryName = libraryName
        self.requiresPassword = requiresPassword
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(libraryName)
                .font(.title2)
            // Idea: validate card number on entering?
            VStack {
                TextField(text: $cardNumber, prompt: Text("Card number")) {
                    //Text("\(Image(systemName: "creditcard"))")
                    //Label("", image: Image(systemName: "creditcard"))
                    //Label("", systemImage: "creditcard")
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
                // TODO: Approach to doing this such that last 4 digits are visible?
                // (If it isn't focused, display the last four digits?)
                /*
                Button {
                    withAnimation {
                        cardNumberVisible.toggle()
                    }
                } label: {
                    if cardNumberVisible {
                        Image(systemName: "eye")
                    } else {
                        Image(systemName: "eye.slash")
                    }
                }
                .tint(.black)
                 */
            
            Button {
                // TODO: Implement auth task
            } label: {
                Text("Authenticate")
            }
            .buttonStyle(.bordered)
        }
    }
}

#Preview {
    LibraryCredentialsView(
        name: "Norlin Library"
    )
}
