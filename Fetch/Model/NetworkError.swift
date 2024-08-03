//
//  NetworkError.swift
//  Fetch
//
//  Created by Shane Brelesky on 8/3/24.
//

enum NetworkError: Error {
    
    case generic
    case badURL
    case requestFailed
    case decodingFailed
    
    var description: String {
        switch self {
        case .generic:
            return "Something went wrong. Please check your connection and try again."
        case .badURL:
            return "The URL provided was invalid. Please try again."
        case .requestFailed:
            return "The request failed. Please check your network connection and try again."
        case .decodingFailed:
            return "Failed to decode the response. Please try again later."
        }
    }
}
