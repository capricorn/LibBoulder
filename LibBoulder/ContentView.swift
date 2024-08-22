//
//  ContentView.swift
//  LibBoulder
//
//  Created by Collin Palmer on 8/19/24.
//

import SwiftUI

struct ContentView: View {
    @State private var displaySettings = false
    
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
            AccountOverviewView()
            Spacer()
        }
        .environment(\.logoutController, {
            // TODO
            /*
            Task {
                await MainActor.run {
                    LoginView()
                    withAnimation {
                        self.libraryCardNumber = nil
                    }
                }
            }
             */
        })
        .sheet(isPresented: $displaySettings) {
            SettingsView()
        }
    }
}

#Preview {
    ContentView()
}
