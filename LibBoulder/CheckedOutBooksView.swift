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
    @StateObject private var viewModel: CheckedOutBooksViewModel = CheckedOutBooksViewModel()
    
    var body: some View {
        VStack {
            if viewModel.loading {
                ProgressView()
            } else {
                List(viewModel.books) { book in
                    Text(book.title)
                }
                .refreshable {
                    // TODO: Handle refresh
                    Task {
                        do {
                            try await viewModel.fetchBooks(libraryCardNumber: libraryCardNumber!)
                        } catch {
                            print("Failed to fetch books: \(error)")
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.libCatAPI = libCatAPI
        }
        .task {
            // TODO: Handle auth error here and logout if needed
            do {
                try await viewModel.fetchBooks(libraryCardNumber: libraryCardNumber!)
            } catch {
                print("Failed to fetch books: \(error)")
            }
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
