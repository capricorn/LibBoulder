//
//  LibCatAPI.swift
//  LibBoulder
//
//  Created by Collin Palmer on 8/19/24.
//

import Foundation

protocol LibCatAPIRepresentable {
    static var baseURL: URL { get }
    func login(cardNumber: String) async throws
    func fetchCheckedOutBooks() async throws -> CheckedOutBooksModel
}

class LibCatAPI: LibCatAPIRepresentable {
    static let baseURL = URL(string: "https://libcat-597bd308b192.herokuapp.com")!
    
    func login(cardNumber: String) async throws {
        var req = URLRequest(url: LibCatAPI.baseURL.appending(component: "login"))
        let jsonBody = [
            "library_card_no": cardNumber
        ]
        
        req.httpBody = try JSONSerialization.data(withJSONObject: jsonBody)
        req.httpMethod = "POST"
        
        let (data, resp) = try await URLSession.shared.data(for: req)
        
        //URLSession.shared.configuration.httpCookieStorage.
        for cookie in (URLSession.shared.configuration.httpCookieStorage?.cookies ?? []) {
            print("Cookie: \(cookie.name)")
        }
    }
    
    func fetchCheckedOutBooks() async throws -> CheckedOutBooksModel {
        var req = URLRequest(url: LibCatAPI.baseURL.appending(component: "checked_out"))
        let (data, resp) = try await URLSession.shared.data(for: req)
        
        return try JSONDecoder().decode(CheckedOutBooksModel.self, from: data)
    }
}
