//
//  ContentView.swift
//  LibBoulder
//
//  Created by Collin Palmer on 8/19/24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage(UserDefaultKey.libraryCardNumber.rawValue) private var libraryCardNumber: String?
    
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
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
