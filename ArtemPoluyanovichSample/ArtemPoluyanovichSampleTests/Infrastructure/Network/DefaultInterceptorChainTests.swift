//
//  DefaultInterceptorChainTests.swift
//  ArtemPoluyanovichSample
//
//  Created by Artiom Poluyanovich on 3/12/2025.
//

@testable import ArtemPoluyanovichSample
import Foundation
import Testing

@Suite("DefaultInterceptorChain Tests")
struct DefaultInterceptorChainTests {
    
    @Test("calls interceptors in order")
    func callsInterceptorsInOrder() async throws {
        var callOrder: [String] = []
        
        let interceptor1 = MockInterceptor { request, chain in
            callOrder.append("interceptor1")
            return try await chain.proceed(request)
        }
        
        let interceptor2 = MockInterceptor { request, chain in
            callOrder.append("interceptor2")
            return try await chain.proceed(request)
        }
        
        let sessionExecutor = MockSessionExecutor.success()
        let chain = DefaultInterceptorChain(
            interceptors: [interceptor1, interceptor2],
            index: 0,
            sessionExecutor: sessionExecutor
        )
        
        let request = URLRequest(url: URL(string: "https://api.example.com/test")!)
        
        _ = try await chain.proceed(request)
        
        #expect(callOrder == ["interceptor1", "interceptor2"])
        #expect(sessionExecutor.executeCallCount == 1)
    }
    
    @Test("calls session executor when no more interceptors")
    func callsSessionExecutorWhenNoMoreInterceptors() async throws {
        let sessionExecutor = MockSessionExecutor.success()
        let chain = DefaultInterceptorChain(
            interceptors: [],
            index: 0,
            sessionExecutor: sessionExecutor
        )
        
        let request = URLRequest(url: URL(string: "https://api.example.com/test")!)
        
        _ = try await chain.proceed(request)
        
        #expect(sessionExecutor.executeCallCount == 1)
        #expect(sessionExecutor.lastExecuteRequest?.url == request.url)
    }
    
    @Test("passes request through chain")
    func passesRequestThroughChain() async throws {
        var receivedRequests: [URLRequest] = []
        
        let interceptor = MockInterceptor { request, chain in
            receivedRequests.append(request)
            return try await chain.proceed(request)
        }
        
        let sessionExecutor = MockSessionExecutor.success()
        let chain = DefaultInterceptorChain(
            interceptors: [interceptor],
            index: 0,
            sessionExecutor: sessionExecutor
        )
        
        let originalRequest = URLRequest(url: URL(string: "https://api.example.com/test")!)
        
        _ = try await chain.proceed(originalRequest)
        
        #expect(receivedRequests.count == 1)
        #expect(receivedRequests[0].url == originalRequest.url)
        #expect(sessionExecutor.lastExecuteRequest?.url == originalRequest.url)
    }
    
    @Test("handles errors from interceptors")
    func handlesErrorsFromInterceptors() async throws {
        let error = NetworkError.timeout
        
        let interceptor = MockInterceptor { _, _ in
            throw error
        }
        
        let sessionExecutor = MockSessionExecutor.success()
        let chain = DefaultInterceptorChain(
            interceptors: [interceptor],
            index: 0,
            sessionExecutor: sessionExecutor
        )
        
        let request = URLRequest(url: URL(string: "https://api.example.com/test")!)
        
        await #expect(throws: NetworkError.timeout) {
            try await chain.proceed(request)
        }
        
        #expect(sessionExecutor.executeCallCount == 0)
    }
}

// MARK: - MockInterceptor
private final class MockInterceptor: Interceptor, @unchecked Sendable {
    private let handler: (URLRequest, InterceptorChain) async throws -> (Data, URLResponse)
    
    init(handler: @escaping (URLRequest, InterceptorChain) async throws -> (Data, URLResponse)) {
        self.handler = handler
    }
    
    func intercept(_ request: URLRequest, chain: InterceptorChain) async throws -> (Data, URLResponse) {
        return try await handler(request, chain)
    }
}
