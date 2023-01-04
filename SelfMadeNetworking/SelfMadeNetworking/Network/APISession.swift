//
//  APISession.swift
//  SelfMadeNetworking
//
//  Created by Roman Pronskyi on 04.01.2023.
//


import Foundation

final class APISession {
    // MARK: Init
    private init() { }
    
    // MARK: Public
    static let shared = APISession()
}

// MARK: Extension APISessionManagerProtocol
extension APISession: APISessionManagerProtocol {
    var idToken: String? {
        // TODO: Set auth token
        ""
    }
    
    var baseUrlString: String {
        // TODO: Set base url
        ""
    }
    
    var urlSession: URLSession {
        URLSession.shared
    }
}
