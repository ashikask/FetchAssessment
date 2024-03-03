//
//  Requestable.swift
//  FetchAssessment
//
//  Created by ashika kalmady on 2/27/24.
//

import Foundation

public enum RequestData {
    case json([String: Any])
    case urlEncoded([String: Any])
    
    /// Encodes the associated values into `Data` for a `URLRequest`.
    func encode() throws -> Data? {
        switch self {
        case .json(let parameters):
            return try JSONSerialization.data(withJSONObject: parameters, options: [])
        case .urlEncoded(let parameters):
            let queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            var components = URLComponents()
            components.queryItems = queryItems
            return components.query?.data(using: .utf8)
        }
    }
}

/// Protocol defining the requirements for constructing a network request.
public protocol Requestable {
    /// The endpoint containing the URL path and parameters for the request.
    var endpoint: Endpoint { get }
    /// The HTTP method (e.g., GET, POST) to be used for the request.
    var method: HTTPMethod { get }
    /// Headers to be included in the request.
    var headers: [String: String] { get }
    
    var requestData: RequestData? { get }
    /// Constructs a URLRequest configured with the endpoint's properties.
    /// - Throws: An error if URL construction fails.
    /// - Returns: A URLRequest configured for the specific endpoint.
    func asURLRequest() throws -> URLRequest
}


extension Requestable {
    
    /// Constructs a URLRequest based on the request's properties.
    /// - Returns: An  URLRequest 
    func asURLRequest() throws -> URLRequest {
        // Combine the base URL and path to form the full URL.
        guard let baseUrl = URL(string: endpoint.fullURL()) else {
            throw URLError(.badURL)
        }
        let fullPath = baseUrl.appendingPathComponent(endpoint.path)
        // Initialize URLComponents with the baseURL and path
        var request = URLRequest(url: fullPath)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        switch method {
        case .get:
            if let parameters = endpoint.parameters, !parameters.isEmpty {
                // Convert parameters to query items for GET requests.
                var components = URLComponents(url: fullPath, resolvingAgainstBaseURL: false)!
                components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                request.url = components.url
            }
        default:
            // For non-GET requests, if there's requestData, encode it accordingly.
            if let requestData = requestData {
                request.httpBody = try requestData.encode()
                switch requestData {
                case .json:
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                case .urlEncoded:
                    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                }
            }
        }
        // The URLRequest is ready to be returned and used for a network request.
        // Note: This basic setup does not include handling for request headers, body data, or query parameters.
        return request
    }
   
}


/// Defines available HTTP methods for requests.
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    // Extend with other methods as needed.
}
