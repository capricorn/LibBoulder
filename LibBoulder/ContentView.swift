//
//  ContentView.swift
//  LibBoulder
//
//  Created by Collin Palmer on 8/19/24.
//

import SwiftUI

struct ContentView: View {
    @State private var displaySettings = false
    @AppStorage(UserDefaultKey.libraryCardNumber.rawValue) private var libraryCardNumber: String?
    
    var loggedIn: Bool {
        libraryCardNumber != nil
    }
    
    var body: some View {
        VStack {
            HStack {
                Button { 
                    displaySettings = true
                } label: {
                    Image(systemName: "gearshape")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25)
                        .padding(.leading, 8)
                }
                .tint(.black)
                Spacer()
            }
            if loggedIn {
                AccountOverviewView()
            } else {
                LoginView()
            }
            Spacer()
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
        .sheet(isPresented: $displaySettings) {
            SettingsView()
        }
    }
}

#Preview {
    ContentView()
}
