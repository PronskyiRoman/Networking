//
//  Media.swift
//  SelfMadeNetworking
//
//  Created by Roman Pronskyi on 04.01.2023.
//

import Foundation

struct Media {
    let key: MediaKey
    let filename: String
    let data: Data
    let mimeType: String
    init(withData imageData: Data,
         fileName: String = UUID().uuidString,
         mediaFormat: MediaFormat = .image,
         mimeMediaFormat: String = "png",
         forKey key: MediaKey) {
        self.key = key
        self.mimeType = "\(mediaFormat.rawValue)/".appending(mimeMediaFormat)
        self.filename = fileName.appending(".").appending(mimeMediaFormat)
        self.data = imageData
    }
}
