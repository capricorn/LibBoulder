//
//  LibraryAPIRepresentable.swift
//  LibBoulder
//
//  Created by Collin Palmer on 8/27/24.
//

import Foundation

enum LibraryId: CaseIterable, Identifiable {
    case norlin
    case boulder
    
    var name: String {
        switch self {
        case .norlin:
            "Norlin Library"
        case .boulder:
            "Boulder Public Library"
        }
    }
    
    var requiresPassword: Bool {
        switch self {
        case .norlin:
            false
        case .boulder:
            true
        }
    }
    
    var id: Self {
        self
    }
}

protocol LibraryAPIRepresentable: Identifiable {
    var id: LibraryId { get }
    func login(username: String, password: String) async throws
    func fetchCheckedOutBooks() async throws -> CheckedOutBooksModel
}
