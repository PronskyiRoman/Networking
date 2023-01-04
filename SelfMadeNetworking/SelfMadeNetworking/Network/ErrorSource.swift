//
//  ErrorSource.swift
//  SelfMadeNetworking
//
//  Created by Roman Pronskyi on 04.01.2023.
//

import Foundation

enum ErrorSource {
    case somePlace
    
    var uniqueCode: Int {
        switch self {
        default: return -1
        }
    }
    
    var message: String {
        switch self {
        default: return "Error Message"
        }
    }
}
