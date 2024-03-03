//
//  mealDetailEndPoint.swift
//  FetchAssessment
//
//  Created by ashika kalmady on 2/28/24.
//

import Foundation

/// Represents the endpoint for fetching detailed information about a specific meal.
///
/// This struct provides the configuration for making requests to the meal detail endpoint,
/// including the required path, HTTP method, and parameters.
struct MealDetailEndpoint: Endpoint {
    var path: String { "lookup.php" }
    var parameters: [String: Any]?
    
    /// Initializes a new endpoint for fetching detailed information about a meal.
    ///
    /// - Parameter mealId: The unique identifier of the meal to fetch details for.
    init(mealId: String) {
        parameters = ["i": mealId]
    }
}
