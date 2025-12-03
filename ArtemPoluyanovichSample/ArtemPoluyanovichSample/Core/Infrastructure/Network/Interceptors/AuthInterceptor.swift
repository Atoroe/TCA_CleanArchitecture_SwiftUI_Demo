//
//  AuthInterceptor.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import Foundation

// MARK: - AuthInterceptor
final class AuthInterceptor: Interceptor {
    
    private let apiKey: String
    private let queryParameterName: String
    
    init(apiKey: String, queryParameterName: String = "key") {
        self.apiKey = apiKey
        self.queryParameterName = queryParameterName
    }
    
    func intercept(_ request: URLRequest, chain: InterceptorChain) async throws -> (Data, URLResponse) {
        var modifiedRequest = request
        
        guard let url = modifiedRequest.url,
              var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw NetworkError.invalidURL("Failed to parse URL for authentication")
        }
        
        var queryItems = urlComponents.queryItems ?? []
        if !queryItems.contains(where: { $0.name == queryParameterName }) {
            queryItems.append(URLQueryItem(name: queryParameterName, value: apiKey))
            urlComponents.queryItems = queryItems
            
            guard let updatedURL = urlComponents.url else {
                throw NetworkError.invalidURL("Failed to create URL with API key")
            }
            modifiedRequest.url = updatedURL
        }
        
        return try await chain.proceed(modifiedRequest)
    }
}
