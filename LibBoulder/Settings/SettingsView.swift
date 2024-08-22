//
//  SettingsView.swift
//  LibBoulder
//
//  Created by Collin Palmer on 8/22/24.
//

import SwiftUI

// TODO: Hook up to sheet in main view; just add gear icon to ContentView for now

struct SettingsView: View {
    var body: some View {
        List {
            Section {
                LibraryCredentialsView(
                    name: "Norlin Library"
                )
                LibraryCredentialsView(
                    name: "Boulder Public Library",
                    requiresPassword: true
                )
                .disabled(true) // TODO: Enable once BPL auth is supported
            } header: {
                Text("Library Accounts ")
            }
        }
    }
}

#Preview {
    SettingsView()
}
