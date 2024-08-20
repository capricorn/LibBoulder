//
//  LoginView.swift
//  LibBoulder
//
//  Created by Collin Palmer on 8/20/24.
//

import SwiftUI

struct LoginView: View {
    @AppStorage(UserDefaultKey.libraryCardNumber.rawValue) private var libraryCardNumber: String?
    @Environment(\.libCatAPI) var libCatAPI
    @State private var libraryCardNo: String = ""

    var body: some View {
        VStack(alignment: .center) {
            TextField("Library Card Number", text: $libraryCardNo)
                .keyboardType(.numberPad)
                .monospaced()
            // TODO: Loading indicator
            Button("Log in") {
                Task {
                    do {
                        try await libCatAPI.login(cardNumber: libraryCardNo)
                        libraryCardNumber = libraryCardNo
                    } catch {
                        print("Login failed: \(error)")
                    }
                }
            }
        }
    }
}
