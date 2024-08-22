//
//  CheckedOutBooksView.swift
//  LibBoulder
//
//  Created by Collin Palmer on 8/20/24.
//

import SwiftUI
import KeychainAccess

struct AccountOverviewView: View {
    @Environment(\.libCatAPI) var libCatAPI
    @Environment(\.logoutController) var logoutController
    @Environment(\.keychain) var keychain
    @StateObject private var viewModel: AccountOverviewViewModel = AccountOverviewViewModel()
    @State private var libraryCardNumber: String? = nil
    
    var body: some View {
        VStack {
            if let libraryCardNumber {
                if viewModel.loading {
                    ProgressView()
                } else {
                    List(viewModel.books) { book in
                        CheckedOutBookView(book: book)
                    }
                    .refreshable {
                        await viewModel.refreshTask(libraryCardNumber: libraryCardNumber)
                    }
                }
            } else {
                Text("Tap the gear and add a library card.")
            }
        }
        .onAppear {
            viewModel.libCatAPI = libCatAPI
            viewModel.logoutController = logoutController
            libraryCardNumber = try? keychain.get(key: .norlinUsername)
            
            // TODO: Better polling mechanism?
            Task {
                while Task.isCancelled == false {
                    try? await Task.sleep(nanoseconds: UInt64(1e9))
                    await MainActor.run {
                        libraryCardNumber = try? keychain.get(key: .norlinUsername)
                    }
                }
            }
        }
        .task {
            guard let libraryCardNumber else {
                return
            }
            
            await viewModel.refreshTask(libraryCardNumber: libraryCardNumber, initialLoad: true)
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
    
    return AccountOverviewView()
        .environment(\.libCatAPI, LibCatPreviewAPI())
        .defaultAppStorage(defaults)
}
