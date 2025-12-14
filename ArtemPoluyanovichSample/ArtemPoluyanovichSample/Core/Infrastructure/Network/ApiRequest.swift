//
//  ApiRequest.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import Foundation

// MARK: - ApiRequestProtocol
protocol ApiRequestProtocol {
    var baseURL: String { get set}
    var path: String { get set}
    var queryParameters: [String: Any]? { get set}
    var method: RequestMethod { get set }
    var parameters: [String: Any]? { get set}
    var headers: [String: String] { get set}
}

// MARK: - ApiRequest
struct ApiRequest: ApiRequestProtocol {
    // MARK: Properties
    var baseURL: String
    var path: String
    var queryParameters: [String: Any]?
    var method: RequestMethod
    var parameters: [String: Any]?
    var headers: [String: String]
    
    // MARK: Initializer
    init(
        baseURL: String = "",
        path: String,
        queryParameters: [String: Any]? = nil,
        method: RequestMethod,
        parameters: [String: Any]? = nil,
        headers: [String: String] = [:]
    ) {
        self.baseURL = baseURL
        self.path = path
        self.queryParameters = queryParameters
        self.method = method
        self.parameters = parameters
        self.headers = headers
    }
}

// MARK: - RequestMethod
enum RequestMethod: String, Sendable {
    case GET
    case POST
}
