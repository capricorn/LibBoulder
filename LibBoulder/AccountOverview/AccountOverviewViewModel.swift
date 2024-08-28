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
    
    // TODO: Test
    func fetchBooks(keychain: KeychainRepresentable, initialLoad: Bool = false) async throws {
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
        
        var books: [CheckedOutBookModel] = []
        
        for library in LibraryId.allCases {
            guard library.authenticated(keychain: keychain) else {
                continue
            }
            
            guard let username = try? keychain.get(key: library.keychainUsernameKey) else {
                print("Failed to find username key for library: \(library.name)")
                continue
            }
            
            var password = ""
            if let passwordKey = library.keychainPasswordKey {
                guard let pass = try? keychain.get(key: passwordKey) else {
                    print("Failed to find username key for library: \(library.name)")
                    continue
                }
                password = pass
            }
            
            var reauth = false
            let api = library.api
            
            print("Fetching '\(library.name)' books")
            do {
                let libBooks = try await api.fetchCheckedOutBooks().checkedOut
                print("books: \(libBooks)")
                books.append(contentsOf: libBooks)
            } catch let error as URLError {
                print("401; reauthenticating")
                reauth = true
            } catch {
                throw error
            }
            
            if reauth {
                try await api.login(username: username, password: password)
                let libBooks = (try await api.fetchCheckedOutBooks()).checkedOut
                books.append(contentsOf: libBooks)
            }
        }
        
        let collectedBooks = books
        await MainActor.run {
            self.books = collectedBooks
        }
    }
    
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
