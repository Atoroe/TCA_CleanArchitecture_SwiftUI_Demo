//
//  AppEnvironment.swift
//  ArtemPoluyanovichSample
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import Foundation

final class AppEnvironment {
    static let shared = AppEnvironment()
    
    // MARK: - Properties
    
    let environment: Environment
    let appDisplayName: String
    let apiKey: String
    let apiBaseURL: String
    
    // MARK: - Initialization
    
    private init() {
        guard let envString = Self.value(for: .environment),
              let env = Environment(rawValue: envString) else {
            fatalError(EnvironmentError.environmentNotFound.localizedDescription)
        }
        self.environment = env
        
        guard let displayName = Self.value(for: .appDisplayName) else {
            fatalError(EnvironmentError.appDisplayNameNotFound.localizedDescription)
        }
        self.appDisplayName = displayName
        
        guard let apiKey = Self.value(for: .apiKey) else {
            fatalError(EnvironmentError.apiKeyNotFound.localizedDescription)
        }
        self.apiKey = apiKey
        
        guard let apiBaseURL = Self.value(for: .apiBaseURL) else {
            fatalError(EnvironmentError.apiBaseURLNotFound.localizedDescription)
        }
        self.apiBaseURL = apiBaseURL
    }
    
    // MARK: - Private Methods
    
    private static func value(for key: InfoPlistKey) -> String? {
        return Bundle.main.infoDictionary?[key.rawValue] as? String
    }
}

// MARK: - Environment Enum

enum Environment: String {
    case development = "dev"
    case production = "prod"
    
    var isDevelopment: Bool {
        self == .development
    }
    
    var isProduction: Bool {
        self == .production
    }
}

// MARK: - EnvironmentError

enum EnvironmentError: LocalizedError {
    case environmentNotFound
    case appDisplayNameNotFound
    case apiKeyNotFound
    case apiBaseURLNotFound
    
    var errorDescription: String? {
        switch self {
        case .environmentNotFound:
            return NSLocalizedString(
                "environment.error.environmentNotFound",
                value: "ENVIRONMENT not found or invalid in Info.plist",
                comment: "Error message when ENVIRONMENT is missing or invalid"
            )
        case .appDisplayNameNotFound:
            return NSLocalizedString(
                "environment.error.appDisplayNameNotFound",
                value: "APP_DISPLAY_NAME not found in Info.plist",
                comment: "Error message when APP_DISPLAY_NAME is missing"
            )
        case .apiKeyNotFound:
            return NSLocalizedString(
                "environment.error.apiKeyNotFound",
                value: "API_KEY not found in Info.plist",
                comment: "Error message when API_KEY is missing"
            )
        case .apiBaseURLNotFound:
            return NSLocalizedString(
                "environment.error.apiBaseURLNotFound",
                value: "API_BASE_URL not found in Info.plist",
                comment: "Error message when API_BASE_URL is missing"
            )
        }
    }
    
    var localizedDescription: String {
        errorDescription ?? "Unknown environment error"
    }
}
