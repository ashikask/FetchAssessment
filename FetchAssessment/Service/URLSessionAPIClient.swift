//
//  URLSessionAPIClient.swift
//  FetchAssessment
//
//  Created by ashika kalmady on 2/27/24.
//

import Foundation
import Combine

enum APIError: LocalizedError {
    case invalidrequest
    case noResponse
    case statusCodeNotOk
}

// URLSession-based implementation of APIClient.
class URLSessionAPIClient: APIClient {
    private let session: URLSession
    
    // Dependency injection for URLSession to facilitate testing.
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func performRequest<T: Decodable>(_ request: Requestable) -> AnyPublisher<T, Error> {
        // Attempt to create a URLRequest in a do-catch block.
        do {
            let urlRequest = try request.asURLRequest()
            
            // Proceed with the network request using the created URLRequest.
            return URLSession.shared.dataTaskPublisher(for: urlRequest)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .tryMap { result in
                    guard let response = result.response as? HTTPURLResponse,
                          (200...299).contains(response.statusCode) else {
                        throw APIError.statusCodeNotOk
                    }
                    return result.data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .mapError { error in
                    // Map decoding and network errors to your APIError type as needed.
                    // This ensures that any error in the pipeline is converted to an APIError.
                    (error as? APIError) ?? APIError.noResponse
                }
                .eraseToAnyPublisher()
        } catch {
            // Catch block handles errors thrown by request.asURLRequest().
            return Fail(error: APIError.invalidrequest).eraseToAnyPublisher()
        }
    }
}
