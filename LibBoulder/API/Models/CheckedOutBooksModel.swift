//
//  CheckedOutBooksModel.swift
//  LibBoulder
//
//  Created by Collin Palmer on 8/20/24.
//

import Foundation

class CheckedOutBooksModel: Codable {
    let checkedOut: [CheckedOutBookModel]
    
    enum CodingKeys: String, CodingKey {
        case checkedOut = "checked_out"
    }
}
