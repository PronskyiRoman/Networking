//
//  NetworkController.swift
//  SelfMadeNetworking
//
//  Created by Roman Pronskyi on 04.01.2023.
//

import Foundation

class NetworkController {
    // MARK: - Private Property
    private var session = APISession.shared
    
    @discardableResult
    private func dataRequest<D: URLRequestDescriptor>(_ descriptor: D) async throws -> D.ResponseType? {
        let response = try await session.urlRequest(descriptor: descriptor)
        switch response.statusCode {
        case .success: return response.getData()
        case .unauthorized: fallthrough
        default: throw response.statusCode
        }
    }
    
    // MARK: - Public Property
    @discardableResult
    func request<D: URLRequestDescriptor>(_ descriptor: D, sorceCode: ErrorSource = .somePlace) async throws -> D.ResponseType {
        let data = try await dataRequest(descriptor)
        guard let data = data else {
            throw NetworkError.unknown(nil, (sorceCode.message, sorceCode.uniqueCode))
        }
        return data
    }
    
    func emptyRequest<D: URLRequestDescriptor>(_ descriptor: D, sorceCode: ErrorSource = .somePlace) async throws {
        do {
            try await dataRequest(descriptor)
        } catch {
            throw NetworkError.unknown(nil, (sorceCode.message, sorceCode.uniqueCode))
        }
    }
}
