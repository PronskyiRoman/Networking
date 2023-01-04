//
//  NetworkError.swift
//  SelfMadeNetworking
//
//  Created by Roman Pronskyi on 04.01.2023.
//

import Foundation

/// NetworkError used for all network responces
///  sort them by cases
/// - Parameters:
/// - Data?: Error Data reseived from server,
/// - Int: http responce Status code
enum NetworkError: Error {
    case informationalResponses((Data?, Int)?)
    case success((Data?, Int)?)
    case redirectionMessages((Data?, Int)?)
    case unauthorized((Data?, Int)?)
    case failureClientError((Data?, Int)?)
    case failureServerError((Data?, Int)?)
    case unknown(Data?, (String, Int)?)
}

// MARK: Error
extension NetworkError {
    var localizedDescription: String {
        switch self {
        case .informationalResponses(let error),
                .success(let error),
                .redirectionMessages(let error),
                .unauthorized(let error),
                .failureClientError(let error),
                .failureServerError(let error):
            return constructAnError(data: error?.0, statusCode: error?.1)
            
        case .unknown(let errorData, let errorDetails):
            return constructAnUnknownError(data: errorData, message: errorDetails?.0, statusCode: errorDetails?.1)
        }
    }
    
    /// Error Constructor
    /// - Parameters:
    /// - Data?: Valid Json
    /// - Int: http responce Status code
    private func constructAnError(data: Data?, statusCode: Int?) -> String {
        let errorCode: String = statusCode == nil ? "Responce Status code is nil some thing went wrong" : "Responce Status code: \(statusCode ?? 0)"
        let errorMessage: String = data == nil ? "Error Description is nil" : (data?.getJson as? String)?.replacingOccurrences(of: "\n", with: "") ?? "Error is not a valid Json"
        
        return errorCode + "\n" + errorMessage
    }
    
    private func constructAnUnknownError(data: Data?, message: String?, statusCode: Int?) -> String {
        let errorCode: String = statusCode == nil ? "Error Status code is nil" : "Error Status code: \(statusCode ?? 0)"
        let errorMessage: String = message == nil ? "Error message is nil" : "Error message: \(message ?? "")"
        let errorData: String = data == nil ? "Error Description is nil" : (data?.getJson as? String)?.replacingOccurrences(of: "\n", with: "") ?? "Error is not a valid Json"
        
        return errorCode + "\n" + errorMessage + "\n" + errorData
    }
}
