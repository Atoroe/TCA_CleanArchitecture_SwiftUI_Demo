//
//  RetryInterceptor.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import Foundation

// MARK: - RetryInterceptor
final class RetryInterceptor: ResponseInterceptorProtocol {
    // MARK: properties
    private let maxRetries: Int
    private let retryDelay: TimeInterval
    
    // MARK: Initializer
    init(maxRetries: Int = 3, retryDelay: TimeInterval = 5.0) {
        self.maxRetries = maxRetries
        self.retryDelay = retryDelay
    }
    
    // MARK: Public Methods
    
    func interceptResponse(_ response: URLResponse?, data: Data?, error: Error?) async throws -> (Data?, Error?) {
        // Retry logic is handled in RestService, not here
        // This interceptor only marks requests as retryable
        return (data, error)
    }
    
    func shouldRetry(response: URLResponse?, error: Error?) -> Bool {
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
        
        if error != nil {
            return true
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            return (500...599).contains(httpResponse.statusCode)
        }
        
        return false
    }
    
    func delayForAttempt(_ attempt: Int) -> TimeInterval {
        return retryDelay
    }
    
    var retryCount: Int {
        return maxRetries
    }
}
