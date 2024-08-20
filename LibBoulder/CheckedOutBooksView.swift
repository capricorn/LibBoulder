//
//  CheckedOutBooksView.swift
//  LibBoulder
//
//  Created by Collin Palmer on 8/20/24.
//

import SwiftUI

struct CheckedOutBooksView: View {
    @State private var books: [CheckedOutBookModel] = []
    @AppStorage("libraryCardNumber") private var libraryCardNumber: String?

    // TODO: Environment inject?
    let api = LibCatAPI()
    
    var body: some View {
        VStack {
            ForEach(books) { book in
                Text(book.title)
            }
        }
        .task {
            // TODO: Loading indicator
            do {
                // First, check if there is a session cookie available
                let sessionCookie = (URLSession.shared.configuration.httpCookieStorage?.cookies(for: LibCatAPI.baseURL)?.first ?? nil)
                if sessionCookie == nil {
                    try await api.login(cardNumber: libraryCardNumber!)
                }
                
                books = (try await api.fetchCheckedOutBooks()).checkedOut
            } catch {
                print("Failed to fetch books: \(error)")
            }
        }
    }
}
