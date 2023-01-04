//
//  URLRequestDescriptor.swift
//  SelfMadeNetworking
//
//  Created by Roman Pronskyi on 04.01.2023.
//

import Foundation

protocol URLRequestDescriptor {
    associatedtype ResponseType: Codable
    associatedtype EncodedBodyType: Codable
    
    var endPointPath: String { get }
    var httpMethod: HttpMethod { get }
    var response: HttpDtoResponse<ResponseType> { get }
    var httpBody: HttpBody<EncodedBodyType> { get }
    var httpQueryItems: [String: String]? { get }
    var httpHeaders: [String: String]? { get }
}

extension URLRequestDescriptor {
    var httpQueryItems: [String: String]? { return nil }
    var httpHeaders: [String: String]? {
        ["accept": "application/json",
         "Content-Type": "application/json"]
    }
    
    var httpBody: HttpBody<EncodedBodyType> { .init() }
    var response: HttpDtoResponse<ResponseType> { .init() }
}
