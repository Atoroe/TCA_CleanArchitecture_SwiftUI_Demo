//
//  URLProtocolMock.swift
//  ArtemPoluyanovichSample
//
//  Created by Artiom Poluyanovich on 3/12/2025.
//

import Foundation

// MARK: - URLProtocolMock
final class URLProtocolMock: URLProtocol {
    
    // MARK: Static Properties
    private static let lock = NSLock()
    nonisolated(unsafe) private static var _requestHandler: ((URLRequest) throws -> (URLResponse, Data?))?
    
    static var requestHandler: ((URLRequest) throws -> (URLResponse, Data?))? {
        get {
            lock.lock()
            defer { lock.unlock() }
            return _requestHandler
        }
        set {
            lock.lock()
            defer { lock.unlock() }
            _requestHandler = newValue
        }
    }
    
    // MARK: URLProtocol
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = URLProtocolMock.requestHandler else {
            fatalError("Handler is unavailable.")
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        // No-op
    }
}

// MARK: - Convenience Methods
extension URLProtocolMock {
    static func setupMockSession(
        statusCode: Int = 200,
        data: Data? = nil,
        error: Error? = nil
    ) -> URLSession {
        // Reset handler first to avoid interference
        URLProtocolMock.requestHandler = nil
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]
        
        // Set handler before creating session
        URLProtocolMock.requestHandler = { request in
            if let error = error {
                throw error
            }
            
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: statusCode,
                httpVersion: "HTTP/1.1",
                headerFields: nil
            )!
            
            return (response, data)
        }
        
        return URLSession(configuration: configuration)
    }
}
