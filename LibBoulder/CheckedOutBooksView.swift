//
//  CheckedOutBooksView.swift
//  LibBoulder
//
//  Created by Collin Palmer on 8/20/24.
//

import SwiftUI

struct CheckedOutBooksView: View {
    @AppStorage(UserDefaultKey.libraryCardNumber.rawValue) private var libraryCardNumber: String?
    @Environment(\.libCatAPI) var libCatAPI
    @State private var books: [CheckedOutBookModel] = []
    @State private var loading = true

    var body: some View {
        VStack {
            if loading {
                ProgressView()
            } else {
                List(books) { book in
                    Text(book.title)
                }
                .refreshable {
                    Task {
                        do {
                            books = (try await libCatAPI.fetchCheckedOutBooks()).checkedOut
                            print("Refreshed books: \(Date.now)")
                        } catch {
                            print("Failed to refresh books: \(error)")
                        }
                    }
                }
            }
        }
        .task {
            // TODO: Loading indicator
            await MainActor.run {
                loading = true
            }
            
            do {
                // First, check if there is a session cookie available
                let sessionCookie = (URLSession.shared.configuration.httpCookieStorage?.cookies(for: LibCatAPI.baseURL)?.first ?? nil)
                if sessionCookie == nil {
                    try await libCatAPI.login(cardNumber: libraryCardNumber!)
                }
                
                books = (try await libCatAPI.fetchCheckedOutBooks()).checkedOut
                await MainActor.run {
                    withAnimation {
                        loading = false
                    }
                }
            } catch {
                print("Failed to fetch books: \(error)")
            }
        }
        .onAppear {
            print(PreviewAssets.jsonCheckedOut)
        }
    }
}

private struct LibCatPreviewAPI: LibCatAPIRepresentable {
    static let baseURL: URL = LibCatAPI.baseURL
    
    func login(cardNumber: String) async throws {}
    
    func fetchCheckedOutBooks() async throws -> CheckedOutBooksModel {
        return PreviewAssets.jsonCheckedOut
    }
}

#Preview {
    let defaults = UserDefaults(suiteName: "CheckedOutBooksView")!
    // TODO: Make extension for this
    defaults.setValue("123", forKey: UserDefaultKey.libraryCardNumber.rawValue)
    
    return CheckedOutBooksView()
        .environment(\.libCatAPI, LibCatPreviewAPI())
        .defaultAppStorage(defaults)
}
