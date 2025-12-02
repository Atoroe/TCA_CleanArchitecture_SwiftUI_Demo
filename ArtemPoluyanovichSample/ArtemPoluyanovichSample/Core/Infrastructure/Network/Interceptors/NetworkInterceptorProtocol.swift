//
//  NetworkInterceptorProtocol.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import Foundation

protocol NetworkInterceptorProtocol {}

protocol RequestInterceptorProtocol: NetworkInterceptorProtocol {
    func interceptRequest(_ request: inout URLRequest) async throws
}

protocol ResponseInterceptorProtocol: NetworkInterceptorProtocol {
    func interceptResponse(_ response: URLResponse?, data: Data?, error: Error?) async throws -> (Data?, Error?)
}
