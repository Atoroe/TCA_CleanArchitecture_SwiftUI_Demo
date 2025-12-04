//
//  AuthInterceptorTests.swift
//  ArtemPoluyanovichSample
//
//  Created by Artiom Poluyanovich on 3/12/2025.
//

@testable import ArtemPoluyanovichSample
import Foundation
import Testing

@Suite("AuthInterceptor Tests")
struct AuthInterceptorTests {
    
    private let apiKey = "test-api-key-12345"
    
    @Test("adds API key to query parameters when not present")
    func addsApiKeyToQueryParameters() async throws {
        let interceptor = AuthInterceptor(apiKey: apiKey)
        let request = URLRequest(url: URL(string: "https://api.example.com/games")!)
        let chain = MockInterceptorChain.success()
        
        let (_, _) = try await interceptor.intercept(request, chain: chain)
        
        guard let modifiedRequest = chain.lastRequest,
              let url = modifiedRequest.url,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            Issue.record("Failed to parse modified request URL")
            return
        }
        
        #expect(queryItems.contains { $0.name == "key" && $0.value == apiKey })
    }
    
    @Test("does not add API key when already present")
    func doesNotAddApiKeyWhenPresent() async throws {
        let interceptor = AuthInterceptor(apiKey: apiKey)
        let url = URL(string: "https://api.example.com/games?key=existing-key&page=1")!
        let request = URLRequest(url: url)
        let chain = MockInterceptorChain.success()
        
        let (_, _) = try await interceptor.intercept(request, chain: chain)
        
        guard let modifiedRequest = chain.lastRequest,
              let modifiedURL = modifiedRequest.url,
              let components = URLComponents(url: modifiedURL, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            Issue.record("Failed to parse modified request URL")
            return
        }
        
        let keyQueryItems = queryItems.filter { $0.name == "key" }
        #expect(keyQueryItems.count == 1)
        #expect(keyQueryItems.first?.value == "existing-key")
    }
    
    @Test("uses custom query parameter name")
    func usesCustomQueryParameterName() async throws {
        let customParamName = "api_key"
        let interceptor = AuthInterceptor(apiKey: apiKey, queryParameterName: customParamName)
        let request = URLRequest(url: URL(string: "https://api.example.com/games")!)
        let chain = MockInterceptorChain.success()
        
        let (_, _) = try await interceptor.intercept(request, chain: chain)
        
        guard let modifiedRequest = chain.lastRequest,
              let url = modifiedRequest.url,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            Issue.record("Failed to parse modified request URL")
            return
        }
        
        #expect(queryItems.contains { $0.name == customParamName && $0.value == apiKey })
    }
    
    @Test("throws error for invalid URL")
    func throwsErrorForInvalidURL() async throws {
        let interceptor = AuthInterceptor(apiKey: apiKey)
        
        // Create request with nil URL to trigger invalid URL error
        var request = URLRequest(url: URL(string: "https://example.com")!)
        request.url = nil
        let chain = MockInterceptorChain.success()
        
        await #expect(throws: NetworkError.self) {
            try await interceptor.intercept(request, chain: chain)
        }
    }
    
    @Test("preserves existing query parameters")
    func preservesExistingQueryParameters() async throws {
        let interceptor = AuthInterceptor(apiKey: apiKey)
        let url = URL(string: "https://api.example.com/games?page=1&limit=20")!
        let request = URLRequest(url: url)
        let chain = MockInterceptorChain.success()
        
        let (_, _) = try await interceptor.intercept(request, chain: chain)
        
        guard let modifiedRequest = chain.lastRequest,
              let modifiedURL = modifiedRequest.url,
              let components = URLComponents(url: modifiedURL, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            Issue.record("Failed to parse modified request URL")
            return
        }
        
        #expect(queryItems.count == 3)
        #expect(queryItems.contains { $0.name == "page" && $0.value == "1" })
        #expect(queryItems.contains { $0.name == "limit" && $0.value == "20" })
        #expect(queryItems.contains { $0.name == "key" && $0.value == apiKey })
    }
}
