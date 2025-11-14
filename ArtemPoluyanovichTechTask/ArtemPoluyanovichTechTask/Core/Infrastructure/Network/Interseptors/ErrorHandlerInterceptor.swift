//
//  ErrorHandlerInterceptor.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import Foundation

// MARK: - ErrorHandlerInterceptor
final class ErrorHandlerInterceptor: ResponseInterceptorProtocol {
    
    // MARK: - Public Methods
    
    func interceptResponse(_ response: URLResponse?, data: Data?, error: Error?) async throws -> (Data?, Error?) {
        guard let error = error else {
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                
                if (200...299).contains(statusCode) {
                    return (data, nil)
                }
                
                // Map specific HTTP status codes to NetworkError
                switch statusCode {
                case 401:
                    return (data, NetworkError.unauthorized)
                case 403:
                    return (data, NetworkError.forbidden)
                case 404:
                    return (data, NetworkError.notFound)
                case 400...499:
                    // Other client errors
                    return (data, NetworkError.httpError(statusCode: statusCode, data: data))
                case 500...599:
                    // Server errors
                    return (data, NetworkError.httpError(statusCode: statusCode, data: data))
                default:
                    return (data, NetworkError.httpError(statusCode: statusCode, data: data))
                }
            }
            
            return (data, nil)
        }
        
        // Transform common errors to NetworkError
        let transformedError: Error
        if let urlError = error as? URLError {
            transformedError = transformURLError(urlError)
        } else if let networkError = error as? NetworkError {
            transformedError = networkError
        } else {
            transformedError = NetworkError.unknown(error.localizedDescription)
        }
        
        return (data, transformedError)
    }
    
    // MARK: - Private Methods
    
    private func extractErrorMessage(from data: Data?) -> String? {
        guard let data = data,
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let message = json["message"] as? String ?? json["error"] as? String else {
            return nil
        }
        return message
    }
    
    private func transformURLError(_ error: URLError) -> Error {
        switch error.code {
        case .notConnectedToInternet, .networkConnectionLost:
            return NetworkError.noConnection
        case .timedOut:
            return NetworkError.timeout
        case .cannotFindHost, .cannotConnectToHost:
            return NetworkError.noConnection
        case .cancelled:
            return NetworkError.cancelled
        default:
            return NetworkError.unknown(error.localizedDescription)
        }
    }
}
