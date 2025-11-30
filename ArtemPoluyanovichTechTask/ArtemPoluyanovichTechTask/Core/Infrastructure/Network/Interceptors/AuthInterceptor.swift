//
//  AuthInterceptor.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import Foundation

// MARK: - AuthInterceptor
final class AuthInterceptor: RequestInterceptorProtocol {
    
    private let apiKey: String
    private let queryParameterName: String
    
    init(apiKey: String, queryParameterName: String = "wa_key") {
        self.apiKey = apiKey
        self.queryParameterName = queryParameterName
    }
    
    func interceptRequest(_ request: inout URLRequest) async throws {
        guard let url = request.url,
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
            request.url = updatedURL
        }
    }
}
