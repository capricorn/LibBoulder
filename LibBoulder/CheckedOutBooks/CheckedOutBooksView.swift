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
    @Environment(\.logoutController) var logoutController
    @StateObject private var viewModel: CheckedOutBooksViewModel = CheckedOutBooksViewModel()
    
    var body: some View {
        VStack {
            if viewModel.loading {
                ProgressView()
            } else {
                List(viewModel.books) { book in
                    //Text(book.title)
                    CheckedOutBookView(book: book)
                }
                .refreshable {
                    await viewModel.refreshTask(libraryCardNumber: libraryCardNumber!)
                }
            }
        }
        .onAppear {
            viewModel.libCatAPI = libCatAPI
            viewModel.logoutController = logoutController
        }
        .task {
            await viewModel.refreshTask(libraryCardNumber: libraryCardNumber!, initialLoad: true)
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
