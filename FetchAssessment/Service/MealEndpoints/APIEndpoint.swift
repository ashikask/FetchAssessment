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
public protocol Endpoint {
    /// The base URL of the API endpoint. Typically includes the root address
    /// of the API and may include a version path component.
    var baseURL: String { get }
    
    /// The version of the API to be used with this endpoint.
    var version: String { get }
    
    /// The path component for the specific endpoint, appended to the base URL.
    var path: String { get }
    
    /// Parameters for the request. These could be query parameters or body parameters,
    /// depending on the HTTP method and endpoint requirements.
    var parameters: [String: Any]? { get }
    
    /// Constructs the full URL string including the base URL, version, and path.
    /// This method can be used to generate the complete URL string for a request.
    func fullURL() -> String
}

// Default implementation for the Endpoint protocol providing a common base URL.
extension Endpoint {
    /// Provides a default base URL for all endpoints. This implementation ensures
    /// that all conforming types use a consistent API base address.
    ///
    /// - Returns: A `URL` representing the base address of the API.
    var baseURL: String {
        "https://themealdb.com/api/json/"
    }
    
    // Default API version can be specified here if most endpoints use the same version,
    // or you can require each conforming type to specify its own version.
    var version: String {
        "v1/1"
    }
    
    // A default implementation of fullURL that constructs the complete URL string
    func fullURL() -> String {
        return "\(baseURL)\(version)/\(path)"
    }
    
}
