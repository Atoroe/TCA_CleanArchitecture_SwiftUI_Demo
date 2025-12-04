//
//  DefaultInterceptorChain.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import Foundation

// MARK: - DefaultInterceptorChain
final class DefaultInterceptorChain: InterceptorChain, @unchecked Sendable {
    private let interceptors: [Interceptor]
    private let index: Int
    private let sessionExecutor: SessionExecutorProtocol
    
    nonisolated init(
        interceptors: [Interceptor],
        index: Int,
        sessionExecutor: SessionExecutorProtocol
    ) {
        self.interceptors = interceptors
        self.index = index
        self.sessionExecutor = sessionExecutor
    }
    
    func proceed(_ request: URLRequest) async throws -> (Data, URLResponse) {
        if index < interceptors.count {
            let next = DefaultInterceptorChain(
                interceptors: interceptors,
                index: index + 1,
                sessionExecutor: sessionExecutor
            )
            return try await interceptors[index].intercept(request, chain: next)
        } else {
            return try await sessionExecutor.execute(request)
        }
    }
}
