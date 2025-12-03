//
//  LoggerInterceptor.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import Foundation

// MARK: - LoggerInterceptor
final class LoggerInterceptor: Interceptor {
    
    private let enabled: Bool
    private let maskApiKey: (String) -> String
    
    init(enabled: Bool = true) {
        self.enabled = enabled
        self.maskApiKey = { key in
            guard key.count > 8 else { return "****" }
            let prefix = String(key.prefix(4))
            let suffix = String(key.suffix(4))
            return "\(prefix)****\(suffix)"
        }
    }
    
    func intercept(_ request: URLRequest, chain: InterceptorChain) async throws -> (Data, URLResponse) {
        guard enabled else { return try await chain.proceed(request) }
        
        logRequest(request)
        
        do {
            let (data, response) = try await chain.proceed(request)
            logResponse(response, data: data, error: nil)
            return (data, response)
        } catch {
            logResponse(nil, data: nil, error: error)
            throw error
        }
    }
    
    private func logRequest(_ request: URLRequest) {
        guard let url = request.url else { return }
        
        var logMessage = "\n📤 [Network] Request:\n"
        logMessage += "   URL: \(url.absoluteString)\n"
        logMessage += "   Method: \(request.httpMethod ?? "N/A")\n"
        
        // Log headers with masked API key
        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            logMessage += "   Headers:\n"
            for (key, value) in headers.sorted(by: { $0.key < $1.key }) {
                let maskedValue = (key.lowercased().contains("api") || key.lowercased().contains("authorization"))
                    ? maskApiKey(value)
                    : value
                logMessage += "      \(key): \(maskedValue)\n"
            }
        }
        
        // Log body if present
        if let httpBody = request.httpBody,
           let bodyString = String(data: httpBody, encoding: .utf8) {
            logMessage += "   Body: \(bodyString)\n"
        }
        
        print(logMessage)
    }
    
    private func logResponse(_ response: URLResponse?, data: Data?, error: Error?) {
        var logMessage = "\n📥 [Network] Response:\n"
        
        if let httpResponse = response as? HTTPURLResponse {
            logMessage += "   Status Code: \(httpResponse.statusCode)\n"
            logMessage += "   URL: \(httpResponse.url?.absoluteString ?? "N/A")\n"
            
            if !httpResponse.allHeaderFields.isEmpty {
                logMessage += "   Headers:\n"
                for (key, value) in httpResponse.allHeaderFields.sorted(by: {
                    String(describing: $0.key) < String(describing: $1.key)
                }) {
                    logMessage += "      \(key): \(value)\n"
                }
            }
        }
        
        if let error = error {
            logMessage += "   Error: \(error.localizedDescription)\n"
        } else if let data = data {
            let dataSize = ByteCountFormatter.string(fromByteCount: Int64(data.count), countStyle: .memory)
            logMessage += "   Data Size: \(dataSize)\n"
            
            // Log response body preview (first 500 chars)
            if let bodyString = String(data: data, encoding: .utf8) {
                let preview = bodyString.count > 500
                    ? String(bodyString.prefix(500)) + "..."
                    : bodyString
                logMessage += "   Body Preview: \(preview)\n"
            }
        }
        
        print(logMessage)
    }
}
