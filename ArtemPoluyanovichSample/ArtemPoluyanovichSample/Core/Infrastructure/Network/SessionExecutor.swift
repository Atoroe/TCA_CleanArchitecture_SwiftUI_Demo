//
//  SessionExecutor.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import Foundation

// MARK: - SessionExecutorProtocol
protocol SessionExecutorProtocol {
    func execute(_ request: URLRequest) async throws -> (Data, URLResponse)
}

// MARK: - SessionExecutor
final class SessionExecutor: SessionExecutorProtocol {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func execute(_ request: URLRequest) async throws -> (Data, URLResponse) {
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

