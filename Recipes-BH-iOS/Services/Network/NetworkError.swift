//
//  NetworkError.swift
//  Recipes-BH-iOS
//
//  Created by Martin Brianto on 10/11/23.
//

import Foundation

enum NetworkError: Error {
    case badRequest(String)
    case requestFailed(String)
    case forbidden(String)
    case notFound(String)
    case tooManyRequests(String)
    case serverError(String)
    
    var description: String {
        switch self {
        case .badRequest(let message):
            return "Bad Request: \(message)"
        case .requestFailed(let message):
            return "Request Failed: \(message)"
        case .forbidden(let message):
            return "Forbidden: \(message)"
        case .notFound(let message):
            return "Not Found: \(message)"
        case .tooManyRequests(let message):
            return "Too Many Requests: \(message)"
        case .serverError(let message):
            return "Server Error: \(message)"
        }
    }
}
