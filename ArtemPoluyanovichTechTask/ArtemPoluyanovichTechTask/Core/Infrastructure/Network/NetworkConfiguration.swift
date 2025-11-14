//
//  NetworkConfiguration.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import Foundation

//MARK: - NetworkConfiguration
struct NetworkConfiguration {
    // MARK: Properies
    let baseURL: String
    let timeout: TimeInterval
    let maxRetryCount: Int
    let loggingEnabled: Bool
    let defaultHeaders: [String: String]
    
    // MARK: Initializer
    init(
        baseURL: String,
        timeout: TimeInterval = 5,
        maxRetryCount: Int = 3,
        loggingEnabled: Bool = false,
        defaultHeaders: [String: String] = [:]
    ) {
        self.baseURL = baseURL
        self.timeout = timeout
        self.maxRetryCount = maxRetryCount
        self.loggingEnabled = loggingEnabled
        self.defaultHeaders = defaultHeaders
    }
}

// MARK: - Convenience Initializers
extension NetworkConfiguration {
    public static func fromEnvironment() -> NetworkConfiguration {
        let environment = AppEnvironment.shared
        let isDevelopment = environment.environment.isDevelopment
        
        return NetworkConfiguration(
            baseURL: environment.apiBaseURL,
            timeout: 5,
            maxRetryCount: 3,
            loggingEnabled: isDevelopment,
            defaultHeaders: ["Content-Type": "application/json"]
        )
    }
}

