//
//  ContentView.swift
//  LibBoulder
//
//  Created by Collin Palmer on 8/19/24.
//

import SwiftUI

struct ContentView: View {
    // TODO: Get user defaults from environment
    @State private var libraryCardNo: String = ""
    @AppStorage("libraryCardNumber") private var libraryCardNumber: String?
    @Environment(\.libCatAPI) var libCatAPI
    
    var loggedIn: Bool {
        libraryCardNumber != nil
    }
    
    var body: some View {
        // TODO: Initial load, determine if cookie exists. If so, try.
        // Otherwise on 401 a logout will occur.
        VStack {
            if loggedIn {
                CheckedOutBooksView()
            } else {
                VStack(alignment: .center) {
                    TextField("Library Card Number", text: $libraryCardNo)
                        .keyboardType(.numberPad)
                        .monospaced()
                    // TODO: Loading indicator
                    Button("Log in") {
                        Task {
                            do {
                                try await libCatAPI.login(cardNumber: libraryCardNo)
                                UserDefaults.standard.setValue(libraryCardNo, forKey: "libraryCardNumber")
                            } catch {
                                print("Login failed: \(error)")
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
        }
    }
}

#Preview {
    ContentView()
}
