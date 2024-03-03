//
//  MockAPIClient.swift
//  FetchAssessmentTests
//
//  Created by ashika kalmady on 2/28/24.
//

import XCTest
import Combine
@testable import FetchAssessment

/// A mock implementation of `APIClient` used for testing purposes.
///
/// This class allows for simulating network requests and responses, providing a mechanism to inject predefined results for requests
class MockAPIClient: APIClient {
    
    /// A predefined result that this mock client should return when a request is performed
    var result: Result<Data, Error>?
    
    /// Performs a network request based on the specifications of the `Requestable` argument.
    ///
    /// This simulates network interactions based on predefined conditions, aiding in the isolation of tests from real network conditions.
    ///
    /// - Parameter request: The request specification that would normally be sent over the network.
    /// - Returns: An `AnyPublisher` instance that publishes the result of the mocked network request.
    ///   If `result` is `.success`, it attempts to decode the provided data into the expected Decodable type `T`
    ///   and publishes it. If decoding fails or `result` is `.failure`, it publishes the corresponding error.
    func performRequest<T>(_ request: Requestable) -> AnyPublisher<T, Error> where T: Decodable {
        switch result {
        case .success(let data):
            // Attempt to decode the provided data into the specified type `T` and publish the decoded object.
            let decoder = JSONDecoder()
            do {
                let decoded = try decoder.decode(T.self, from: data)
                return Just(decoded)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            } catch {
                // If decoding fails, publish the encountered error.
                return Fail(error: error).eraseToAnyPublisher()
            }
        case .failure(let error):
            // If `result` is a failure, directly publish the provided error.
            return Fail(error: error).eraseToAnyPublisher()
        case .none:
            // If `result` is not set, publish a default error indicating no response.
            return Fail(error: APIError.noResponse).eraseToAnyPublisher()
        }
    }
}
