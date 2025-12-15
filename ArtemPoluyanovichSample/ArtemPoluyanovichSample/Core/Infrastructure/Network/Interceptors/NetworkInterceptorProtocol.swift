//
//  NetworkInterceptorProtocol.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import Foundation

// MARK: - Interceptor
protocol Interceptor: Sendable {
    @concurrent func intercept(_ request: URLRequest, chain: InterceptorChain) async throws -> (Data, URLResponse)
}

// MARK: - InterceptorChain
protocol InterceptorChain: Sendable {
    @concurrent func proceed(_ request: URLRequest) async throws -> (Data, URLResponse)
}
