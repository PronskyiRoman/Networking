//
//  RequestConfigurator.swift
//  SelfMadeNetworking
//
//  Created by Roman Pronskyi on 04.01.2023.
//

import Foundation

final class RequestConfigurator {
    // MARK: Publick func
    func configure<D: URLRequestDescriptor>(_ url: URL, descriptor: D, jwt: String?) -> URLRequest {
        var request = URLRequest(url: url)
        // confifure method
        confifureMethod(&request, descriptor: descriptor)
        
        // confifure headers
        confifureHeaders(&request, descriptor: descriptor)
        
        // confifure credentials
        confifureJwt(&request, jwt: jwt)
        
        // confifure request body
        configureBody(&request, descriptor: descriptor)
        
        return request
    }
    
    // MARK: Private Func
    // confifure headers
    private func confifureHeaders<D: URLRequestDescriptor>(_ request: inout URLRequest, descriptor: D) {
        guard let headers = descriptor.httpHeaders else { return }
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
    }
    
    // confifure method
    private func confifureMethod<D: URLRequestDescriptor>(_ request: inout URLRequest, descriptor: D) {
        request.httpMethod = descriptor.httpMethod.rawValue
    }
    
    // confifure jwt
    private func confifureJwt(_ request: inout URLRequest, jwt: String?) {
        guard let jwt = jwt else { return }
        request.setValue(jwt, forHTTPHeaderField: "Authorization")
    }

    // configure body
    private func configureBody<D: URLRequestDescriptor>(_ request: inout URLRequest, descriptor: D) {
        switch descriptor.httpBody.typeOfContent() {
        case .fromJson: setDataAsBody(for: &request, data: descriptor.httpBody.data().0)
            
        default:
            let httpBody = descriptor.httpBody.data()
            setDataAsBody(for: &request, data: httpBody.0)
            setupHeader(&request, httpBody)
        }
    }
    
    // http multipart data header
    private func setupHeader(_ request: inout URLRequest, _ body: (Data, String?)) {
        request.setValue("multipart/form-data; boundary=\(body.1 ?? "")", forHTTPHeaderField: "Content-Type")
        request.setValue(body.0.count.description, forHTTPHeaderField: "Content-Length")
    }
    
    private func setDataAsBody(for request: inout URLRequest, data: Data) {
        request.httpBody = data
    }
}
