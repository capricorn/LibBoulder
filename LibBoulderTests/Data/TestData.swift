//
//  TestData.swift
//  LibBoulderTests
//
//  Created by Collin Palmer on 8/21/24.
//

import Foundation

@testable import LibBoulder

struct TestData {
    let bundle: Bundle
    
    var jsonCheckedOut: CheckedOutBooksModel {
        try! JSONDecoder().decode(CheckedOutBooksModel.self, from: try! Data(contentsOf: bundle.url(forResource: "checked-out", withExtension: "json")!))
    }
}
