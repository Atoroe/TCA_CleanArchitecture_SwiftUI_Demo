//
//  SessionExecutor.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import Foundation

// MARK: - SessionExecutorProtocol
protocol SessionExecutorProtocol: Sendable {
    @concurrent func execute(_ request: URLRequest) async throws -> (Data, URLResponse)
}

// MARK: - SessionExecutor
// Note: @unchecked Sendable is safe here because:
// - URLSession is Sendable in Swift 6
// - Session is immutable after initialization
// - No mutable state is shared across isolation domains
final class SessionExecutor: SessionExecutorProtocol, @unchecked Sendable {
    private let session: URLSession
    
    nonisolated init(
        session: URLSession? = nil,
        configuration: NetworkConfiguration? = nil
    ) {
        if let session = session {
            self.session = session
        } else if let configuration = configuration {
            let sessionConfiguration = URLSessionConfiguration.default
            sessionConfiguration.timeoutIntervalForRequest = configuration.timeout
            sessionConfiguration.timeoutIntervalForResource = configuration.timeout
            self.session = URLSession(configuration: sessionConfiguration)
        } else {
            self.session = URLSession.shared
        }
    }
    
    @concurrent func execute(_ request: URLRequest) async throws -> (Data, URLResponse) {
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode, data: data)
        }
        
        return (data, response)
    }
}
