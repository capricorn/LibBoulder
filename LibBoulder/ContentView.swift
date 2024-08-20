//
//  ContentView.swift
//  LibBoulder
//
//  Created by Collin Palmer on 8/19/24.
//

import SwiftUI

struct ContentView: View {
    @State private var loggedIn = false
    @State private var libraryCardNo: String = ""
    
    let api = LibCatAPI()
    
    var body: some View {
        // TODO: Initial load, determine if cookie exists. If so, try.
        // Otherwise on 401 a logout will occur.
        if loggedIn {
            Button("Fetch books") {
                
            }
        } else {
            VStack(alignment: .center) {
                TextField("Library Card Number", text: $libraryCardNo)
                    .keyboardType(.numberPad)
                    .monospaced()
                Button("Log in") {
                    Task {
                        do {
                            try await api.login(cardNumber: libraryCardNo)
                            loggedIn = true
                        } catch {
                            print("Login failed: \(error)")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
