//
//  APISessionManagerProtocol.swift
//  SelfMadeNetworking
//
//  Created by Roman Pronskyi on 04.01.2023.
//

import Foundation

protocol APISessionManagerProtocol {
    var urlSession: URLSession { get }
    var baseUrlString: String { get }
    var idToken: String? { get }
    
    func urlRequest<D: URLRequestDescriptor>(descriptor: D) async throws -> HttpDtoResponse<D.ResponseType>
}

extension APISessionManagerProtocol {
    func urlRequest<D: URLRequestDescriptor>(descriptor: D) async throws -> HttpDtoResponse<D.ResponseType> {
        try await dataTask(descriptor)
    }
    
    var idToken: String? {
        return nil
    }
}

private extension APISessionManagerProtocol {
    func constructURL<D: URLRequestDescriptor>(_ descriptor: D) -> URL {
        guard let baseUrl = URL(string: baseUrlString) else {
            preconditionFailure("Incorrect baseUrlString!")
        }
        
        var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
        components?.path += descriptor.endPointPath
        components?.queryItems = descriptor.httpQueryItems?.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        guard let url = components?.url else {
            preconditionFailure("Incorrect url!")
        }
        
        return url
    }
    
    func urlRequest<D: URLRequestDescriptor>(_ descriptor: D) -> URLRequest {
        RequestConfigurator().configure(constructURL(descriptor), descriptor: descriptor, jwt: idToken)
    }
    
    func dataTask<D: URLRequestDescriptor>(_ descriptor: D) async throws -> HttpDtoResponse<D.ResponseType> {
        let urlRequest = urlRequest(descriptor)
        let (data, response) = try await urlSession.data(for: urlRequest)
        return descriptor.response.updateSelf(by: (response as? HTTPURLResponse)?.statusCode, and: data)
    }
}
