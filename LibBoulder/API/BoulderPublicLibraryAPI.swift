//
//  BoulderPublicLibraryAPI.swift
//  LibBoulder
//
//  Created by Collin Palmer on 8/27/24.
//

import Foundation

class BoulderPublicLibraryAPI: LibraryAPIRepresentable {
    private static let baseURL = URL(string: "https://libcat-597bd308b192.herokuapp.com/bpl")!
    
    var id: LibraryId {
        .boulder
    }
    
    func login(username: String, password: String) async throws {
        var req = URLRequest(url: LibCatAPI.baseURL.appending(component: "login"))
        let jsonBody = [
            "username": username,
            "password": password
        ]
        
        req.httpBody = try JSONSerialization.data(withJSONObject: jsonBody)
        req.httpMethod = "POST"
        
        let (data, resp) = try await URLSession.shared.data(for: req)
    }
    
    func fetchCheckedOutBooks() async throws -> CheckedOutBooksModel {
        var req = URLRequest(url: LibCatAPI.baseURL.appending(component: "checked_out"))
        let (data, resp) = try await URLSession.shared.data(for: req)
        
        if let httpResp = resp as? HTTPURLResponse, httpResp.statusCode == 401 {
            throw URLError(.userAuthenticationRequired)
        }
        
        return try JSONDecoder().decode(CheckedOutBooksModel.self, from: data)
    }
}
