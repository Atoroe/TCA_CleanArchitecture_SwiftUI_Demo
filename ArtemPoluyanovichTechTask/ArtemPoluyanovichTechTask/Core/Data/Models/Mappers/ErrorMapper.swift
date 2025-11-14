//
//  ErrorMapper.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import Foundation

enum ErrorMapper {
    
    static func toAppError(_ networkError: NetworkError) -> AppError {
        switch networkError {
        case .httpError(let statusCode, let data):
            let errorMessage = extractErrorMessage(from: data)
            return .api(code: statusCode, message: errorMessage)
            
        case .unauthorized:
            return .api(code: 401, message: "Unauthorized access")
            
        case .forbidden:
            return .api(code: 403, message: "Access forbidden")
            
        case .notFound:
            return .api(code: 404, message: "Resource not found")
            
        case .timeout:
            return .network(reason: "Request timeout")
            
        case .noConnection:
            return .network(reason: "No internet connection")
            
        case .decodingError(let message):
            return .unknown(message: message)
            
        case .encodingError(let message):
            return .unknown(message: message)
            
        case .cancelled:
            return .network(reason: "Request cancelled")
            
        case .invalidURL(let url):
            return .network(reason: "Invalid URL: \(url)")
            
        case .invalidRequest(let reason):
            return .network(reason: "Invalid request: \(reason)")
            
        case .invalidResponse:
            return .network(reason: "Invalid response from server")
            
        case .noData:
            return .network(reason: "No data received from server")
            
        case .unknown(let message):
            return .unknown(message: message)
        }
    }
    
    // MARK: - Private Helpers
    
    private static func extractErrorMessage(from data: Data?) -> String? {
        guard let data else { return nil }
        
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }
        
        if let message = json["message"] as? String, !message.isEmpty {
            return message
        }
        
        if let error = json["error"] as? String, !error.isEmpty {
            return error
        }
        
        return nil
    }
}
