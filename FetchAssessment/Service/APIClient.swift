//
//  APIClient.swift
//  FetchAssessment
//
//  Created by ashika kalmady on 2/27/24.
//

import Foundation
import Combine

// Defines the requirements for any API client, such as making network requests.
public protocol APIClient {
    func performRequest<T: Decodable>(_ request: Requestable) -> AnyPublisher<T, Error>
}
