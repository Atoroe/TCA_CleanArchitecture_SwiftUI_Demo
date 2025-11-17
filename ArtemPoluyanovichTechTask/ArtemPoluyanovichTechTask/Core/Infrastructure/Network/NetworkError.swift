//
//  NetworkError.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import Foundation

// MARK: - NetworkError
enum NetworkError: Error, LocalizedError {
    case httpError(statusCode: Int, data: Data?)
    case unauthorized
    case forbidden
    case notFound
    case timeout
    case noConnection
    case invalidURL(String)
    case invalidRequest(String)
    case invalidResponse
    case noData
    case decodingError(String)
    case encodingError(String)
    case cancelled
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .httpError(let statusCode, let data):
            if let data = data, let errorMessage = String(data: data, encoding: .utf8) {
                return "HTTP error (\(statusCode)): \(errorMessage)"
            }
            return "HTTP error (\(statusCode))"
        case .unauthorized:
            return "Unauthorized access (401)"
        case .forbidden:
            return "Access forbidden (403)"
        case .notFound:
            return "Resource not found (404)"
        case .timeout:
            return "Request timeout"
        case .noConnection:
            return "No internet connection"
        case .invalidURL(let url):
            return "Invalid URL: \(url)"
        case .invalidRequest(let reason):
            return "Invalid request: \(reason)"
        case .invalidResponse:
            return "Invalid response from server"
        case .noData:
            return "No data received from server"
        case .decodingError(let message):
            return "Decoding error: \(message)"
        case .encodingError(let message):
            return "Encoding error: \(message)"
        case .cancelled:
            return "Request cancelled"
        case .unknown(let message):
            return "Unknown error: \(message)"
        }
    }
}
