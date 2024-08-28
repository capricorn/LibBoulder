//
//  CheckedOutBookModel.swift
//  LibBoulder
//
//  Created by Collin Palmer on 8/20/24.
//

import Foundation

class CheckedOutBookModel: Codable, Identifiable {
    let libraryId: LibraryId?
    let title: String
    let author: String
    //let renewCount: Int
    let dueDate: Date
    let id = UUID()
    
    enum CodingKeys: String, CodingKey {
        case libraryId = "library_id"
        case title
        case author
        case renewCount = "renew_count"
        case dueDate = "due_date_iso8601"
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.author = try container.decode(String.self, forKey: .author)
        //self.renewCount = try container.decode(Int.self, forKey: .renewCount)
        let dueDateISO8601 = try container.decode(String.self, forKey: .dueDate)
        
        let dueDate = ISO8601DateFormatter().date(from: dueDateISO8601)
        guard let dueDate else {
            throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.dueDate], debugDescription: "iso8601 incorrectly formatted: \(dueDateISO8601)"))
        }
        
        self.dueDate = dueDate
        if let libraryIdRawValue = try container.decodeIfPresent(String.self, forKey: .libraryId) {
            self.libraryId = LibraryId(rawValue: libraryIdRawValue)
        } else {
            self.libraryId = nil
        }
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.title, forKey: .title)
        try container.encode(self.author, forKey: .author)
        //try container.encode(self.renewCount, forKey: .renewCount)
        try container.encode(self.dueDate.formatted(.iso8601), forKey: .dueDate)
        try container.encodeIfPresent(libraryId?.rawValue, forKey: .libraryId)
    }
}
