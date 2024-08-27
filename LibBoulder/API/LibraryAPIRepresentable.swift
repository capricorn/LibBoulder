//
//  LibraryAPIRepresentable.swift
//  LibBoulder
//
//  Created by Collin Palmer on 8/27/24.
//

import Foundation

enum LibraryId {
    case norlin
    case boulder
}

protocol LibraryAPIRepresentable: Identifiable {
    var id: LibraryId { get }
    func login(username: String, password: String) async throws
    func fetchCheckedOutBooks() async throws -> CheckedOutBooksModel
}
