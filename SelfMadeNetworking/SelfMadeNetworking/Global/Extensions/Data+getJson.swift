//
//  Data+getJson.swift
//  SelfMadeNetworking
//
//  Created by Roman Pronskyi on 04.01.2023.
//

import Foundation

extension Data {
    var getJson: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedJson = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else {
            return nil
        }
        return prettyPrintedJson
    }
}
