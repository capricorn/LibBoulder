//
//  CheckedOutBooksViewModel.swift
//  LibBoulder
//
//  Created by Collin Palmer on 8/21/24.
//

import SwiftUI

class AccountOverviewViewModel: ObservableObject {
    var libCatAPI: LibCatAPIRepresentable!
    var logoutController: LogoutController!
    
    @Published var loading = false
    @Published var books: [CheckedOutBookModel] = []
    
    func fetchBooks(libraryCardNumber: String, initialLoad: Bool = false) async throws {
        if initialLoad {
            await MainActor.run {
                loading = true
            }
        }
        
        defer {
            if initialLoad {
                Task {
                    await MainActor.run {
                        withAnimation {
                            loading = false
                        }
                    }
                }
            }
        }
        
        var reauth = false
        
        do {
            let books = (try await libCatAPI.fetchCheckedOutBooks()).checkedOut
            await MainActor.run {
                self.books = books
            }
        } catch let error as URLError {
            print("401; reauthenticating")
            reauth = true
        } catch {
            throw error
        }
        
        if reauth {
            try await libCatAPI.login(cardNumber: libraryCardNumber)
            let books = (try await libCatAPI.fetchCheckedOutBooks()).checkedOut
            await MainActor.run {
                self.books = books
            }
        }
    }
    
    func refreshTask(libraryCardNumber: String, initialLoad: Bool = false) async {
        do {
            try await fetchBooks(libraryCardNumber: libraryCardNumber, initialLoad: initialLoad)
        } catch let error as URLError {
            if error.code == .userAuthenticationRequired {
                print("401 -- logging out")
                logoutController()
            }
        } catch {
            print("Failed to fetch books: \(error)")
        }
    }
}
