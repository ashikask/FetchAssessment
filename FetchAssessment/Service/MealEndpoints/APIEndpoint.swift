//
//  APIEndpoint.swift
//  FetchAssessment
//
//  Created by ashika kalmady on 2/28/24.
//

import Foundation

/// A protocol that defines the essential properties of an API endpoint.
///
/// Conforming types will specify the URL components required to construct a network request,
/// including the base URL, path, method, and any parameters.
protocol Endpoint {
    /// The base URL of the API endpoint. Typically includes the root address
    /// of the API and may include a version path component.
    var baseURL: URL { get }
    
    /// The path component for the specific endpoint, appended to the base URL.
    var path: String { get }
    
    /// The HTTP method (e.g., GET, POST) used for requests to this endpoint.
    var method: HTTPMethod { get }
    
    /// Parameters for the request. These could be query parameters or body parameters,
    /// depending on the HTTP method and endpoint requirements.
    var parameters: [String: Any]? { get }
}

// Default implementation for the Endpoint protocol providing a common base URL.
extension Endpoint {
    /// Provides a default base URL for all endpoints. This implementation ensures
    /// that all conforming types use a consistent API base address.
    ///
    /// - Returns: A `URL` representing the base address of the API.
    var baseURL: URL {
        URL(string: "https://themealdb.com/api/json/v1/")!
    }
}
