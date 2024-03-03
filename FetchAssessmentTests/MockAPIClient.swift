//
//  MockAPIClient.swift
//  FetchAssessmentTests
//
//  Created by ashika kalmady on 2/28/24.
//

import XCTest
import Combine// Import your module
@testable import FetchAssessment

class MockAPIClient: APIClient {
    var result: Result<Data, Error>?
    
    func performRequest<T>(_ request: Requestable) -> AnyPublisher<T, Error> where T: Decodable {
        switch result {
        case .success(let data):
            let decoder = JSONDecoder()
            do {
                let decoded = try decoder.decode(T.self, from: data)
                return Just(decoded).setFailureType(to: Error.self).eraseToAnyPublisher()
            } catch {
                return Fail(error: error).eraseToAnyPublisher()
            }
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        case .none:
            return Fail(error: APIError.noResponse).eraseToAnyPublisher()
        }
    }
}
