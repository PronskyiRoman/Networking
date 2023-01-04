//
//  HttpBody.swift
//  SelfMadeNetworking
//
//  Created by Roman Pronskyi on 04.01.2023.
//

import Foundation
import SwiftUI

struct HttpBody<EncodedBodyType: Codable> {
    // MARK: Properties
    private let contentType: HttpContentType
    private var media: [Media]?
    private var parameters: [String: String]?
    private var jsonModel: EncodedBodyType?
    
    // MARK: Init
    /// Optional init for diffetent sorts of source body for HTTP Requests
    init() {
        self.contentType = .fromJson
    }
    
    init(media: [Media]?) {
        self.contentType = .fromData
        self.media = media
    }
    
    init(parameters: [String: String]?) {
        self.contentType = .fromParameters
        self.parameters = parameters
    }
    
    init(media: [Media]?, parameters: [String: String]?) {
        self.contentType = .combinedParametersAndData
        self.media = media
        self.parameters = parameters
    }
    
    init(model: EncodedBodyType?) {
        self.contentType = .fromJson
        self.jsonModel = model
    }
    
    init(images: [UIImage]?) {
        self.contentType = .fromData
        guard let images = images else { return }
        self.media = mapToMedia(images)
    }
    
    // MARK: public interface
    // content type
    func typeOfContent() -> HttpContentType {
        contentType
    }
    
    /// Data func used to decode all sorts of data to correct Data format
    /// - Returns:
    /// - Data :  correct encoded Data
    /// - String : Boundary used to create data body
    func data() -> (Data, String?) {
        let boundary = generateBoundary()
        var body = Data()
        
        switch contentType {
        case .fromData: body.append(generateData(from: media, boundary: boundary))
        case .fromJson: body.append(generateData(from: jsonModel))
        case .fromParameters: body.append(generateData(from: parameters, boundary: boundary))
            
        case .combinedParametersAndData:
            body.append(generateData(from: parameters, boundary: boundary))
            body.append(generateData(from: media, boundary: boundary))
        }
        
        guard contentType != .fromJson else {
            return (body, nil)
        }
        
        closeBody(for: &body, boundary: boundary)
        
        return (body, boundary)
    }
    
    // MARK: Private func
    private func generateBoundary() -> String {
        "Boundary-\(NSUUID().uuidString)"
    }
    
    private var lineBreak: String {
        "\r\n"
    }
    
    private func generateData(from parameters: [String: String]?, boundary: String) -> Data {
        var body = Data()
        if let parameters = parameters {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        
        return body
    }
    
    private func generateData(from json: EncodedBodyType?) -> Data {
        var body = Data()
        guard let json = json else { return body }
        do {
            body.append(try JSONEncoder().encode(json))
        } catch {
            print("Can not decode body to Json ", error.localizedDescription)
        }
        
        return body
    }
    
    private func generateData(from media: [Media]?, boundary: String) -> Data {
        var body = Data()
        if let media = media {
            for item in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(item.key)\"; filename=\"\(item.filename)\"\(lineBreak)")
                body.append("Content-Type: \(item.mimeType + lineBreak + lineBreak)")
                body.append(item.data)
                body.append(lineBreak)
            }
        }
        
        return body
    }
    
    private func closeBody(for data: inout Data, boundary: String) {
        data.append("--\(boundary)--\(lineBreak)")
    }
    
    private func mapToMedia(_ images: [UIImage]) -> [Media] {
        images.map({ Media(withData: $0.jpegData(compressionQuality: 1) ?? Data(), mimeMediaFormat: "jpg" , forKey: .image) })
    }
}
