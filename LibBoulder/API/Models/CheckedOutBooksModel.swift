//
//  CheckedOutBooksModel.swift
//  LibBoulder
//
//  Created by Collin Palmer on 8/20/24.
//

import Foundation

class CheckedOutBooksModel: Codable {
    let checkedOut: [CheckedOutBookModel]
    let libraryId: LibraryId?
    
    enum CodingKeys: String, CodingKey {
        case checkedOut = "checked_out"
        case libraryId = "library_id"
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(checkedOut, forKey: .checkedOut)
        try container.encodeIfPresent(libraryId?.rawValue, forKey: .libraryId)
    }
    
    required init(from decoder: any Decoder) throws {
        var container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.checkedOut = try container.decode([CheckedOutBookModel].self, forKey: .checkedOut)
        if let libraryIdRawValue = try container.decodeIfPresent(String.self, forKey: .libraryId) {
            self.libraryId = LibraryId(rawValue: libraryIdRawValue)
        } else {
            self.libraryId = nil
        }
    }
}
