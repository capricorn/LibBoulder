//
//  LibBoulderApp.swift
//  LibBoulder
//
//  Created by Collin Palmer on 8/19/24.
//

import SwiftUI

@main
struct LibBoulderApp: App {
    let libCatAPI = LibCatAPI()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.libCatAPI, libCatAPI)
        }
    }
}
