//
//  ErrorHandlerInterceptor.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import Foundation

// MARK: - ErrorHandlerInterceptor
final class ErrorHandlerInterceptor: Interceptor, @unchecked Sendable {
    
    // MARK: - Public Methods
    
    @concurrent func intercept(_ request: URLRequest, chain: InterceptorChain) async throws -> (Data, URLResponse) {
        do {
            return try await chain.proceed(request)
        } catch {
            throw transformError(error)
        }
    }
    
    // MARK: - Private Methods
    
    private func transformError(_ error: Error) -> Error {
        if let urlError = error as? URLError {
            return transformURLError(urlError)
        }
        
        if let networkError = error as? NetworkError {
            if case .httpError(let statusCode, let data) = networkError {
                return mapHttpStatusCode(statusCode, data: data)
            }
            return networkError
        }
        
        return NetworkError.unknown(error.localizedDescription)
    }
    
    private func mapHttpStatusCode(_ statusCode: Int, data: Data?) -> Error {
        switch statusCode {
        case 401:
            return NetworkError.unauthorized
        case 403:
            return NetworkError.forbidden
        case 404:
            return NetworkError.notFound
        default:
            return NetworkError.httpError(statusCode: statusCode, data: data)
        }
    }
    
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
