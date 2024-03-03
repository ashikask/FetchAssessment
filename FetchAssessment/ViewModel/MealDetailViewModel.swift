//
//  MealDetailViewModel.swift
//  FetchAssessment
//
//  Created by ashika kalmady on 2/27/24.
//

import Foundation
import Combine

public protocol MealDetailViewModelProtocol: ObservableObject {
    var mealDetail: Meal? { get set }
    func fetchMealDetail()
}

public class MealDetailViewModel: MealDetailViewModelProtocol, ObservableObject {
    @Published public var mealDetail: Meal?
    private var cancellables = Set<AnyCancellable>()
    private let apiClient: APIClient
    private var mealId: String?
    
    // Adjusted to conform to protocol
    public func fetchMealDetail() {
        guard let mealId = mealId else { return }
        
        let request = MealRequest(detailForMealId: mealId)
        
        apiClient.performRequest(request)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                // Handle completion
            }, receiveValue: { [weak self] (response: MealsResponse) in
                self?.mealDetail = response.meals.first
            })
            .store(in: &cancellables)
    }
    
    // initializer to accept an APIClient instance and an optional mealId
    init(apiClient: APIClient, mealId: String? = nil) {
        self.apiClient = apiClient
        self.mealId = mealId
    }
    
    // Optional: Setter for mealId if needed later
    func setMealId(_ mealId: String) {
        self.mealId = mealId
    }
}


