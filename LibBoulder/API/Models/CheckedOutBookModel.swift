//
//  CheckedOutBookModel.swift
//  LibBoulder
//
//  Created by Collin Palmer on 8/20/24.
//

import Foundation

class CheckedOutBookModel: Codable, Identifiable {
    let title: String
    let author: String
    let renewCount: Int
    let dueDate: String
    let id = UUID()
    
    enum CodingKeys: String, CodingKey {
        case title
        case author
        case renewCount = "renew_count"
        case dueDate = "due_date"
    }
}
