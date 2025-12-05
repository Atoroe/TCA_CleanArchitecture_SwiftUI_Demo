//
//  RetryInterceptorTests.swift
//  ArtemPoluyanovichSample
//
//  Created by Artiom Poluyanovich on 3/12/2025.
//

@testable import ArtemPoluyanovichSample
import Foundation
import Testing
import Clocks

@Suite("RetryInterceptor Tests")
struct RetryInterceptorTests {
    
    @Test("successful request without retry")
    func successfulRequestWithoutRetry() async throws {
        let interceptor = RetryInterceptor(maxRetries: 3)
        let request = URLRequest(url: URL(string: "https://api.example.com/games")!)
        let chain = MockInterceptorChain.success()
        
        let (_, _) = try await interceptor.intercept(request, chain: chain)
        
        #expect(chain.proceedCallCount == 1)
    }
    
    @Test("retries on timeout error")
    func retriesOnTimeoutError() async throws {
        let interceptor = RetryInterceptor(maxRetries: 2)
        let request = URLRequest(url: URL(string: "https://api.example.com/games")!)
        
        var callCount = 0
        let chain = MockInterceptorChain.custom { _ in
            callCount += 1
            if callCount == 1 {
                throw NetworkError.timeout
            }
            return (Data(), HTTPURLResponse())
        }
        
        let (_, _) = try await interceptor.intercept(request, chain: chain)
        
        #expect(callCount == 2)
    }
    
    @Test("retries on 5xx error")
    func retriesOn5xxError() async throws {
        let interceptor = RetryInterceptor(maxRetries: 2)
        let request = URLRequest(url: URL(string: "https://api.example.com/games")!)
        
        var callCount = 0
        let chain = MockInterceptorChain.custom { _ in
            callCount += 1
            if callCount == 1 {
                throw NetworkError.httpError(statusCode: 500, data: nil)
            }
            return (Data(), HTTPURLResponse())
        }
        
        let (_, _) = try await interceptor.intercept(request, chain: chain)
        
        #expect(callCount == 2)
    }
    
    @Test("does not retry on 4xx error")
    func doesNotRetryOn4xxError() async throws {
        let interceptor = RetryInterceptor(maxRetries: 3)
        let request = URLRequest(url: URL(string: "https://api.example.com/games")!)
        
        let chain = MockInterceptorChain.failure(NetworkError.unauthorized)
        
        await #expect(throws: NetworkError.self) {
            try await interceptor.intercept(request, chain: chain)
        }
        
        #expect(chain.proceedCallCount == 1)
    }
    
    @Test("retries on URLError connection issues")
    func retriesOnURLErrorConnectionIssues() async throws {
        let interceptor = RetryInterceptor(maxRetries: 2)
        let request = URLRequest(url: URL(string: "https://api.example.com/games")!)
        
        var callCount = 0
        let chain = MockInterceptorChain.custom { _ in
            callCount += 1
            if callCount == 1 {
                throw URLError(.notConnectedToInternet)
            }
            return (Data(), HTTPURLResponse())
        }
        
        let (_, _) = try await interceptor.intercept(request, chain: chain)
        
        #expect(callCount == 2)
    }
    
    @Test("respects max retries limit")
    func respectsMaxRetriesLimit() async throws {
        let maxRetries = 2
        let interceptor = RetryInterceptor(maxRetries: maxRetries)
        let request = URLRequest(url: URL(string: "https://api.example.com/games")!)
        
        let chain = MockInterceptorChain.failure(NetworkError.timeout)
        
        await #expect(throws: NetworkError.self) {
            try await interceptor.intercept(request, chain: chain)
        }
        
        #expect(chain.proceedCallCount == maxRetries + 1)
    }
    
    @Test("applies retry delay between attempts")
    func appliesRetryDelayBetweenAttempts() async throws {
        let retryDelay: TimeInterval = 0.1
        let mockClock = MockClock()
        
        let interceptor = RetryInterceptor(maxRetries: 2, retryDelay: retryDelay, clock: mockClock.clock())
        let request = URLRequest(url: URL(string: "https://api.example.com/games")!)
        
        var callTimes: [Date] = []
        let chain = MockInterceptorChain.custom { _ in
            callTimes.append(Date())
            if callTimes.count < 3 {
                throw NetworkError.timeout
            }
            return (Data(), HTTPURLResponse())
        }
        
        let (_, _) = try await interceptor.intercept(request, chain: chain)
        
        #expect(mockClock.sleepCallCount == 2)
        
        // Verify delays between attempts with tolerance for timing precision
        let expectedDuration = Duration.seconds(retryDelay)
        let tolerance = Duration.milliseconds(10)
        for duration in mockClock.sleepDurations {
            let minDuration = expectedDuration - tolerance
            let maxDuration = expectedDuration + tolerance
            #expect(duration >= minDuration && duration <= maxDuration, "Duration \(duration) should be within \(tolerance) of \(expectedDuration)")
        }
    }
    
    @Test("does not retry on forbidden error")
    func doesNotRetryOnForbiddenError() async throws {
        let interceptor = RetryInterceptor(maxRetries: 3)
        let request = URLRequest(url: URL(string: "https://api.example.com/games")!)
        
        let chain = MockInterceptorChain.failure(NetworkError.forbidden)
        
        await #expect(throws: NetworkError.self) {
            try await interceptor.intercept(request, chain: chain)
        }
        
        #expect(chain.proceedCallCount == 1)
    }
    
    @Test("does not retry on not found error")
    func doesNotRetryOnNotFoundError() async throws {
        let interceptor = RetryInterceptor(maxRetries: 3)
        let request = URLRequest(url: URL(string: "https://api.example.com/games")!)
        
        let chain = MockInterceptorChain.failure(NetworkError.notFound)
        
        await #expect(throws: NetworkError.self) {
            try await interceptor.intercept(request, chain: chain)
        }
        
        #expect(chain.proceedCallCount == 1)
    }
}
