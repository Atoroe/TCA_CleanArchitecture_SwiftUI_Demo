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
    private let urlSession: URLSession
    private let interceptors: [NetworkInterceptorProtocol]
    
    // MARK: Initializer
    init(configuration: NetworkConfiguration, interceptors: [NetworkInterceptorProtocol] = []) {
        self.configuration = configuration
        self.interceptors = interceptors
        
        // Configure URLSession with timeout from configuration
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = configuration.timeout
        sessionConfiguration.timeoutIntervalForResource = configuration.timeout
        self.urlSession = URLSession(configuration: sessionConfiguration)
    }
    
    // MARK: Public Methods
    
    nonisolated func send<ResultType: Decodable>(_ request: ApiRequestProtocol) async throws -> ResultType {
        var urlRequest = try await buildURLRequest(request)
        
        try await applyRequestInterceptors(&urlRequest)
        
        let (data, _) = try await executeWithRetry(request: urlRequest)
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ResultType.self, from: data)
            return decodedData
        } catch {
            throw NetworkError.decodingError(error.localizedDescription)
        }
    }
    
    // MARK: Private methods
    
    private func applyRequestInterceptors(_ request: inout URLRequest) async throws {
        for interceptor in interceptors {
            if let requestInterceptor = interceptor as? RequestInterceptorProtocol {
                try await requestInterceptor.interceptRequest(&request)
            }
        }
    }
    
    private func applyResponseInterceptors(_ response: URLResponse?, data: Data?, error: Error?) async throws -> (Data?, Error?) {
        var currentData = data
        var currentError = error
        
        for interceptor in interceptors.reversed() {
            if let responseInterceptor = interceptor as? ResponseInterceptorProtocol {
                let result = try await responseInterceptor.interceptResponse(response, data: currentData, error: currentError)
                currentData = result.0 ?? currentData
                currentError = result.1 ?? currentError
            }
        }
        
        return (currentData, currentError)
    }
    
    private func executeWithRetry(request: URLRequest) async throws -> (Data, URLResponse) {
        let retryInterceptor = interceptors.first(where: { $0 is RetryInterceptor }) as? RetryInterceptor
        
        guard let retryInterceptor = retryInterceptor else {
            // No retry interceptor, execute once
            return try await sendDataRequest(request)
        }
        
        for attempt in 1...retryInterceptor.retryCount {
            do {
                let result = try await sendDataRequest(request)
                return result
            } catch {
                // Check if error is retryable
                if retryInterceptor.shouldRetry(response: nil, error: error) {
                    if attempt < retryInterceptor.retryCount {
                        let delay = retryInterceptor.delayForAttempt(attempt)
                        try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                        continue
                    }
                }
                throw error
            }
        }
        
        // All retries failed
        throw NetworkError.unknown("Request failed after \(retryInterceptor.retryCount) retry attempts")
    }
    
    @discardableResult
    private func sendDataRequest(_ request: URLRequest) async throws -> (Data, URLResponse) {
        do {
            let (data, response) = try await urlSession.data(for: request)
            
            let (processedData, processedError) = try await applyResponseInterceptors(response, data: data, error: nil)
            
            if let error = processedError {
                throw error
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.httpError(statusCode: httpResponse.statusCode, data: processedData)
            }
            
            let finalData = processedData ?? data
            
            return (finalData, response)
        } catch {
            let (_, processedError) = try await applyResponseInterceptors(nil, data: nil, error: error)
            
            if let networkError = processedError as? NetworkError {
                throw networkError
            } else if let processedError = processedError {
                throw NetworkError.unknown(processedError.localizedDescription)
            } else {
                throw NetworkError.unknown(error.localizedDescription)
            }
        }
    }
    
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
        
        headers.forEach() {
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

