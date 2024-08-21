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
        VStack {
            if loggedIn {
                AccountOverviewView()
            } else {
                LoginView()
            }
        }
        .environment(\.logoutController, {
            Task {
                await MainActor.run {
                    withAnimation {
                        self.libraryCardNumber = nil
                    }
                }
            }
        })
    }
}

#Preview {
    ContentView()
}
