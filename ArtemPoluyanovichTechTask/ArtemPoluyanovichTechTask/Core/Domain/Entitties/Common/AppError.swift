//
//  Error.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import Foundation

enum AppError: Error, LocalizedError, Equatable {
    case api(code: Int, message: String?)
    case network(reason: String)
    case unknown(message: String)
    
    public var errorDescription: String? {
        switch self {
        case .api(let code, let message):
            return message ?? "API error with code: \(code)"
        case .network(let reason):
            return "Network error: \(reason)"
        case .unknown(let message):
            return "Unknown error: \(message)"
        }
    }
    
    public static func == (lhs: AppError, rhs: AppError) -> Bool {
        switch (lhs, rhs) {
        case (.api(let lhsCode, let lhsMsg), .api(let rhsCode, let rhsMsg)):
            return lhsCode == rhsCode && lhsMsg == rhsMsg
        case (.network(let lhsReason), .network(let rhsReason)):
            return lhsReason == rhsReason
        case (.unknown(let lhsMsg), .unknown(let rhsMsg)):
            return lhsMsg == rhsMsg
        default:
            return false
        }
    }
}
