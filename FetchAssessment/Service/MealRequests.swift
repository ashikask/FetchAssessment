//
//  MealRequests.swift
//  FetchAssessment
//
//  Created by ashika kalmady on 2/27/24.
//

import Foundation

struct MealRequest: Requestable {
    
    var endpoint: Endpoint
    var method: HTTPMethod { .get }
    var headers: [String: String] { [:] }
    var requestData: RequestData? { nil }
    
    // Specific initializer for fetching meal list
    init(listForCategory category: String) {
        self.endpoint = MealsListEndpoint(category: category)
    }
    
    // Specific initializer for fetching meal details
    init(detailForMealId mealId: String) {
        self.endpoint = MealDetailEndpoint(mealId: mealId)
    }
    
}

