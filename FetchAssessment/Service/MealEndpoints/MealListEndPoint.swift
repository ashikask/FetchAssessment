//
//  MealListEndPoint.swift
//  FetchAssessment
//
//  Created by ashika kalmady on 2/28/24.
//

import Foundation

/// Represents the endpoint for fetching a list of meals by category.
///
/// This struct conforms to the `Endpoint` protocol and specifies the path,
/// method, and parameters required to fetch meals from a specific category.
struct MealsListEndpoint: Endpoint {
    var path: String { "filter.php" }
    var parameters: [String: Any]?
    
    /// Initializes a new endpoint for fetching meals by category.
    ///
    /// - Parameter category: The category of meals to fetch.
    init(category: String) {
        parameters = ["c": category]
    }
}
