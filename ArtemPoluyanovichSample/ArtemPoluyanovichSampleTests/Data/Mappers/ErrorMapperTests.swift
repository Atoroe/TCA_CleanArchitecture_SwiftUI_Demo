//
//  ErrorMapperTests.swift
//  ArtemPoluyanovichSample
//
//  Created by Artiom Poluyanovich on 2/12/2025.
//

@testable import ArtemPoluyanovichSample
import Foundation
import Testing

@Suite("ErrorMapper Tests")
struct ErrorMapperTests {
    
    @Test("maps httpError with message from data")
    func mapsHttpErrorWithMessage() {
        let jsonData = """
        {"message": "Invalid request parameters"}
        """.data(using: .utf8)!
        
        let networkError = NetworkError.httpError(statusCode: 400, data: jsonData)
        let appError = ErrorMapper.toAppError(networkError)
        
        #expect(appError == .api(code: 400, message: "Invalid request parameters"))
    }
    
    @Test("maps httpError with error field from data")
    func mapsHttpErrorWithErrorField() {
        let jsonData = """
        {"error": "Authentication failed"}
        """.data(using: .utf8)!
        
        let networkError = NetworkError.httpError(statusCode: 401, data: jsonData)
        let appError = ErrorMapper.toAppError(networkError)
        
        #expect(appError == .api(code: 401, message: "Authentication failed"))
    }
    
    @Test("maps httpError with no data")
    func mapsHttpErrorWithNoData() {
        let networkError = NetworkError.httpError(statusCode: 500, data: nil)
        let appError = ErrorMapper.toAppError(networkError)
        
        #expect(appError == .api(code: 500, message: nil))
    }
    
    @Test("maps unauthorized error")
    func mapsUnauthorizedError() {
        let networkError = NetworkError.unauthorized
        let appError = ErrorMapper.toAppError(networkError)
        
        #expect(appError == .api(code: 401, message: "Unauthorized access"))
    }
    
    @Test("maps forbidden error")
    func mapsForbiddenError() {
        let networkError = NetworkError.forbidden
        let appError = ErrorMapper.toAppError(networkError)
        
        #expect(appError == .api(code: 403, message: "Access forbidden"))
    }
    
    @Test("maps notFound error")
    func mapsNotFoundError() {
        let networkError = NetworkError.notFound
        let appError = ErrorMapper.toAppError(networkError)
        
        #expect(appError == .api(code: 404, message: "Resource not found"))
    }
    
    @Test("maps timeout error")
    func mapsTimeoutError() {
        let networkError = NetworkError.timeout
        let appError = ErrorMapper.toAppError(networkError)
        
        #expect(appError == .network(reason: "Request timeout"))
    }
    
    @Test("maps noConnection error")
    func mapsNoConnectionError() {
        let networkError = NetworkError.noConnection
        let appError = ErrorMapper.toAppError(networkError)
        
        #expect(appError == .network(reason: "No internet connection"))
    }
    
    @Test("maps cancelled error")
    func mapsCancelledError() {
        let networkError = NetworkError.cancelled
        let appError = ErrorMapper.toAppError(networkError)
        
        #expect(appError == .network(reason: "Request cancelled"))
    }
    
    @Test("maps invalidURL error")
    func mapsInvalidURLError() {
        let networkError = NetworkError.invalidURL("https://invalid")
        let appError = ErrorMapper.toAppError(networkError)
        
        #expect(appError == .network(reason: "Invalid URL: https://invalid"))
    }
    
    @Test("maps invalidRequest error")
    func mapsInvalidRequestError() {
        let networkError = NetworkError.invalidRequest("Missing parameters")
        let appError = ErrorMapper.toAppError(networkError)
        
        #expect(appError == .network(reason: "Invalid request: Missing parameters"))
    }
    
    @Test("maps invalidResponse error")
    func mapsInvalidResponseError() {
        let networkError = NetworkError.invalidResponse
        let appError = ErrorMapper.toAppError(networkError)
        
        #expect(appError == .network(reason: "Invalid response from server"))
    }
    
    @Test("maps noData error")
    func mapsNoDataError() {
        let networkError = NetworkError.noData
        let appError = ErrorMapper.toAppError(networkError)
        
        #expect(appError == .network(reason: "No data received from server"))
    }
    
    @Test("maps decodingError")
    func mapsDecodingError() {
        let networkError = NetworkError.decodingError("Failed to decode response")
        let appError = ErrorMapper.toAppError(networkError)
        
        #expect(appError == .unknown(message: "Failed to decode response"))
    }
    
    @Test("maps encodingError")
    func mapsEncodingError() {
        let networkError = NetworkError.encodingError("Failed to encode request")
        let appError = ErrorMapper.toAppError(networkError)
        
        #expect(appError == .unknown(message: "Failed to encode request"))
    }
}
