//
//  MockInterceptorChain.swift
//  ArtemPoluyanovichSample
//
//  Created by Artiom Poluyanovich on 3/12/2025.
//

@testable import ArtemPoluyanovichSample
import Foundation

// MARK: - MockInterceptorChain
final class MockInterceptorChain: InterceptorChain, @unchecked Sendable {
    
    // MARK: Properties
    private let behavior: Behavior
    private(set) var proceedCallCount = 0
    private(set) var lastRequest: URLRequest?
    
    // MARK: Behavior
    enum Behavior {
        case success(Data, URLResponse)
        case failure(Error)
        case custom((URLRequest) async throws -> (Data, URLResponse))
    }
    
    // MARK: Initializer
    init(behavior: Behavior) {
        self.behavior = behavior
    }
    
    // MARK: InterceptorChain
    func proceed(_ request: URLRequest) async throws -> (Data, URLResponse) {
        proceedCallCount += 1
        lastRequest = request
        
        switch behavior {
        case .success(let data, let response):
            return (data, response)
        case .failure(let error):
            throw error
        case .custom(let handler):
            return try await handler(request)
        }
    }
}

// MARK: - Convenience Methods
extension MockInterceptorChain {
    static func success(_ data: Data = Data(), response: URLResponse = HTTPURLResponse()) -> MockInterceptorChain {
        MockInterceptorChain(behavior: .success(data, response))
    }
    
    static func failure(_ error: Error) -> MockInterceptorChain {
        MockInterceptorChain(behavior: .failure(error))
    }
    
    static func custom(_ handler: @escaping (URLRequest) async throws -> (Data, URLResponse)) -> MockInterceptorChain {
        MockInterceptorChain(behavior: .custom(handler))
    }
}

