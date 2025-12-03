//
//  RetryInterceptor.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import Foundation

// MARK: - RetryInterceptor
final class RetryInterceptor: Interceptor {
    // MARK: properties
    private let maxRetries: Int
    private let retryDelay: TimeInterval
    
    // MARK: Initializer
    init(maxRetries: Int = 3, retryDelay: TimeInterval = 5.0) {
        self.maxRetries = maxRetries
        self.retryDelay = retryDelay
    }
    
    // MARK: Public Methods
    
    func intercept(_ request: URLRequest, chain: InterceptorChain) async throws -> (Data, URLResponse) {
        var lastError: Error?
        
        for attempt in 0...maxRetries {
            do {
                if attempt > 0 {
                    try await Task.sleep(nanoseconds: UInt64(retryDelay * 1_000_000_000))
                }
                return try await chain.proceed(request)
            } catch {
                lastError = error
                if !shouldRetry(error) {
                    throw error
                }
            }
        }
        
        throw lastError ?? NetworkError.unknown("Request failed after \(maxRetries) retries")
    }
    
    private func shouldRetry(_ error: Error) -> Bool {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .timeout, .noConnection:
                return true
            case .httpError(let statusCode, _):
                return (500...599).contains(statusCode)
            case .unauthorized, .forbidden, .notFound:
                return false
            default:
                return false
            }
        }
        
        // For other errors (like URLError), we might want to retry connection issues
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost, .timedOut, .cannotFindHost, .cannotConnectToHost:
                return true
            default:
                return false
            }
        }
        
        return false
    }
}
