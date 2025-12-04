//
//  SessionExecutorTests.swift
//  ArtemPoluyanovichSample
//
//  Created by Artiom Poluyanovich on 3/12/2025.
//

@testable import ArtemPoluyanovichSample
import Foundation
import Testing

@Suite("SessionExecutor Tests", .serialized)
final class SessionExecutorTests {
    
    // MARK: - Cleanup
    deinit {
        // Reset handler after each test to avoid interference
        URLProtocolMock.requestHandler = nil
    }
    
    @Test("successful request returns data and response")
    func successfulRequestReturnsDataAndResponse() async throws {
        let testData = "{\"message\": \"success\"}".data(using: .utf8)!
        let mockSession = URLProtocolMock.setupMockSession(statusCode: 200, data: testData)
        let executor = SessionExecutor(session: mockSession)
        
        let request = URLRequest(url: URL(string: "https://api.example.com/test")!)
        
        let (data, response) = try await executor.execute(request)
        
        #expect(data == testData)
        #expect((response as? HTTPURLResponse)?.statusCode == 200)
    }
    
    @Test("http error throws NetworkError")
    func httpErrorThrowsNetworkError() async throws {
        let mockSession = URLProtocolMock.setupMockSession(statusCode: 404)
        let executor = SessionExecutor(session: mockSession)
        
        let request = URLRequest(url: URL(string: "https://api.example.com/not-found")!)
        
        await #expect(throws: NetworkError.self) {
            try await executor.execute(request)
        }
    }
    
    @Test("invalid response throws NetworkError")
    func invalidResponseThrowsNetworkError() async throws {
        // Create a session that returns non-HTTP response
        URLProtocolMock.requestHandler = nil
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]
        
        URLProtocolMock.requestHandler = { request in
            let response = URLResponse(
                url: request.url!,
                mimeType: nil,
                expectedContentLength: 0,
                textEncodingName: nil
            )
            return (response, Data())
        }
        
        let mockSession = URLSession(configuration: configuration)
        let executor = SessionExecutor(session: mockSession)
        
        let request = URLRequest(url: URL(string: "https://api.example.com/test")!)
        
        await #expect(throws: NetworkError.invalidResponse) {
            try await executor.execute(request)
        }
    }
    
    @Test("initialization with custom session")
    func initializationWithCustomSession() {
        let customSession = URLSession.shared
        let executor = SessionExecutor(session: customSession)
        _ = executor
    }
    
    @Test("initialization with configuration")
    func initializationWithConfiguration() {
        let configuration = NetworkConfiguration(
            baseURL: "https://api.example.com",
            timeout: 10,
            maxRetryCount: 3,
            loggingEnabled: false
        )
        
        let executor = SessionExecutor(configuration: configuration)
        _ = executor
    }
    
    @Test("initialization with default session")
    func initializationWithDefaultSession() {
        let executor = SessionExecutor()
        _ = executor
    }
}
