//
//  HttpDtoResponse.swift
//  SelfMadeNetworking
//
//  Created by Roman Pronskyi on 04.01.2023.
//

import Foundation

final class HttpDtoResponse<ResponseType: Codable> {
    // MARK: Value
    // http response status code
    private var code: Int?
    // http response data
    private var data: Data?
    
    // MARK: init
    init(decoder: DecodingStrategy = .defaultStrategy) {
        self.decoderStrategy = decoder
    }
    
    // MARK: Public Response Data
    func getData() -> ResponseType? {
        guard let data = data, !data.isEmpty else { return nil }
        
        // to possability download images from network as data type
        if ResponseType.self is Data.Type {
            return data as? ResponseType
        }
        
        // to possability download some Json objects from network
        do {
            let decoder = getDecoder()
            let decodedData = try decoder.decode(ResponseType.self, from: data)
            return decodedData
        } catch let error as NSError {
            // if get crach here
            // it means you have to check the data structure
            // it can't be decoded from received server data
            assertionFailure("Throw Error: Decoding Error: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    // MARK: Public Error Data
    var statusCode: NetworkError {
        guard let code = code else { return .unknown(nil, ("http code is nil", -1)) }
        
        switch code {
        case 100...199: return .informationalResponses((data, code))
        case 200...299: return .success((data, code))
        case 300...399: return .redirectionMessages((data, code))
        case 400: return .failureClientError((data, code))
        // .unauthorized == the account was removed or server have some trouble with given user
        case 401...403: return .unauthorized((data, code))
        case 404...499: return .failureClientError((data, code))
        case 500...599: return .failureServerError((data, code))
            
        default: return .unknown(data, ("Unknown http code", code))
        }
    }
    
    // MARK: updateSelf
    func updateSelf(by code: Int?, and data: Data?) -> HttpDtoResponse<ResponseType> {
        self.code = code
        self.data = data
        
        return self
    }
    
    // MARK: Private Decoder
    private let decoderStrategy: DecodingStrategy
    
    // configure decoder
    private func getDecoder() -> JSONDecoder {
        let decoder: JSONDecoder = JSONDecoder()
        
        switch decoderStrategy {
        case .defaultStrategy: break
        case .fromSnakeCaseStrategy: decoder.keyDecodingStrategy = .convertFromSnakeCase
        }
        
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        
        return decoder
    }
}
