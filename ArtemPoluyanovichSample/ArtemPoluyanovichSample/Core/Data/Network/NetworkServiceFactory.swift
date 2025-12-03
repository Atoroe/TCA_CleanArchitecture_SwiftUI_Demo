//
//  NetworkServiceFactory.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

final class NetworkServiceFactory {
    static func createRestService() -> RestServiceProtocol {
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
