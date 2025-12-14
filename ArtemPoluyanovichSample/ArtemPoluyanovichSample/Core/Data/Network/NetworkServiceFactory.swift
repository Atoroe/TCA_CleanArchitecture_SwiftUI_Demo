//
//  NetworkServiceFactory.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

// Note: @unchecked Sendable is safe here because:
// - Only static methods, no instance state
// - All dependencies are Sendable
final class NetworkServiceFactory: @unchecked Sendable {
    nonisolated static func createRestService() -> RestServiceProtocol {
        let config = NetworkConfiguration.fromEnvironment()
        
        let interceptors: [Interceptor] = [
            AuthInterceptor(apiKey: AppEnvironment.shared.apiKey),
            RetryInterceptor(maxRetries: config.maxRetryCount),
            ErrorHandlerInterceptor(),
            LoggerInterceptor(enabled: config.loggingEnabled)
        ]
        
        return RestService(configuration: config, interceptors: interceptors)
    }
}
