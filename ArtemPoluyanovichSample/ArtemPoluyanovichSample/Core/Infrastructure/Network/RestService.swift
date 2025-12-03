//
//  RestService.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import Foundation

// MARK: - RestServiceProtocol
protocol RestServiceProtocol {
    nonisolated func send<ResultType: Decodable>(_ request: ApiRequestProtocol) async throws -> ResultType
}

// MARK: RestService
final class RestService: RestServiceProtocol {
    
    // MARK: Properties
    private let configuration: NetworkConfiguration
    private let interceptors: [Interceptor]
    private let sessionExecutor: SessionExecutorProtocol
    
    // MARK: Initializer
    init(
        configuration: NetworkConfiguration,
        interceptors: [Interceptor] = [],
        sessionExecutor: SessionExecutorProtocol? = nil
    ) {
        self.configuration = configuration
        self.interceptors = interceptors
        
        // Configure URLSession with timeout from configuration
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = configuration.timeout
        sessionConfiguration.timeoutIntervalForResource = configuration.timeout
        let session = URLSession(configuration: sessionConfiguration)
        
        self.sessionExecutor = sessionExecutor ?? SessionExecutor(session: session)
    }
    
    // MARK: Public Methods
    
    nonisolated func send<ResultType: Decodable>(_ request: ApiRequestProtocol) async throws -> ResultType {
        let urlRequest = try await buildURLRequest(request)
        
        let chain = DefaultInterceptorChain(
            interceptors: interceptors,
            index: 0,
            sessionExecutor: sessionExecutor
        )
        
        let (data, _) = try await chain.proceed(urlRequest)
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ResultType.self, from: data)
            return decodedData
        } catch {
            throw NetworkError.decodingError(error.localizedDescription)
        }
    }
    
    // MARK: Private Methods
    
    private func buildURLRequest(_ request: ApiRequestProtocol) async throws -> URLRequest {
        let baseURL = request.baseURL.isEmpty ? configuration.baseURL : request.baseURL
        let fullPath = baseURL + request.path
        
        guard let urlComponent = NSURLComponents(string: fullPath) else {
            throw NetworkError.invalidURL(fullPath)
        }
        if let queryDictionary = request.queryParameters {
            urlComponent.queryItems = queryDictionary.map {
                URLQueryItem(name: $0, value: $1 as? String)
            }
        }
        guard let url = urlComponent.url else {
            throw NetworkError.invalidURL(fullPath)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        var headers = configuration.defaultHeaders
        request.headers.forEach { headers[$0.key] = $0.value }
        
        headers.forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        if let parameters = request.parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch {
                throw NetworkError.encodingError(error.localizedDescription)
            }
        }
        return urlRequest
    }
}
