//
//  CheckedOutBooksViewModel.swift
//  LibBoulder
//
//  Created by Collin Palmer on 8/21/24.
//

import SwiftUI

class CheckedOutBooksViewModel: ObservableObject {
    var libCatAPI: LibCatAPIRepresentable!
    
    @Published var loading = false
    @Published var books: [CheckedOutBookModel] = []
    
    func fetchBooks(libraryCardNumber: String) async throws {
        await MainActor.run {
            loading = true
        }
        
        defer {
            Task {
                await MainActor.run {
                    withAnimation {
                        loading = false
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
}
