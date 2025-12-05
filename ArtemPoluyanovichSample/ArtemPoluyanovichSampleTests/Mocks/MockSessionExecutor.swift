//
//  MockSessionExecutor.swift
//  ArtemPoluyanovichSample
//
//  Created by Artiom Poluyanovich on 3/12/2025.
//

@testable import ArtemPoluyanovichSample
import Foundation

final class MockSessionExecutor: SessionExecutorProtocol, @unchecked Sendable {
    var executeBehavior: (URLRequest) async throws -> (Data, URLResponse)
    var executeCallCount = 0
    var lastExecuteRequest: URLRequest?
    
    init(executeBehavior: @escaping (URLRequest) async throws -> (Data, URLResponse)) {
        self.executeBehavior = executeBehavior
    }
    
    func execute(_ request: URLRequest) async throws -> (Data, URLResponse) {
        executeCallCount += 1
        lastExecuteRequest = request
        return try await executeBehavior(request)
    }
}

// MARK: - Convenience Methods
extension MockSessionExecutor {
    static func success(_ data: Data = Data(), _ response: URLResponse = HTTPURLResponse()) -> MockSessionExecutor {
        MockSessionExecutor { _ in (data, response) }
    }
    
    static func failure(_ error: Error) -> MockSessionExecutor {
        MockSessionExecutor { _ in throw error }
    }
    
    static func httpSuccess(_ data: Data = Data(), statusCode: Int = 200) -> MockSessionExecutor {
        let response = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
        return MockSessionExecutor { _ in (data, response) }
    }
    
    static func httpError(statusCode: Int, data: Data? = nil) -> MockSessionExecutor {
        _ = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
        return MockSessionExecutor { _ in throw NetworkError.httpError(statusCode: statusCode, data: data) }
    }
}

