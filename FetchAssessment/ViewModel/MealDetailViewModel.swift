//
//  MealDetailViewModel.swift
//  FetchAssessment
//
//  Created by ashika kalmady on 2/27/24.
//

import Foundation
import Combine

protocol MealDetailViewModelProtocol: ObservableObject {
    var mealDetail: Meal? { get set }
    func fetchMealDetail()
}

class MealDetailViewModel: MealDetailViewModelProtocol, ViewModelStateProtocol, ObservableObject {
    @Published var mealDetail: Meal?
    @Published private(set) var state: ViewModelState<Meal> = .idle
    private var cancellables = Set<AnyCancellable>()
    private let apiClient: APIClient
    private let mealId: String
    
    // Fetch the meal detail for the meal id from the api and update the UI
    func fetchMealDetail() {
        self.state = .loading
        let mealId = mealId
        let request = MealRequest(detailForMealId: mealId)
        
        apiClient.performRequest(request)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                // Handle the completion of the subscription.
                switch completion {
                case .failure(let error):
                    // If there's an error, update the state to reflect the failure.
                    self?.state = .failed("Failed to fetch meal details: \(error.localizedDescription)")
                case .finished:
                    // No action needed for the .finished case at the moment.
                    break
                }
            }, receiveValue: { [weak self] (response: MealsResponse) in
                // Update the mealDetail with the first meal from the response.
                guard let mealDetail = response.meals.first else {
                    // If there are no meals in the response, update the state to .empty.
                    self?.state = .empty
                    return
                }
                
                // If a meal is found, update mealDetail and set the state to .loaded.
                self?.mealDetail = mealDetail
                self?.state = .loaded(mealDetail)
            })
            .store(in: &cancellables)
        
    }
    
    // initializer to accept an APIClient instance and an optional mealId
    init(apiClient: APIClient, mealId: String) {
        self.apiClient = apiClient
        self.mealId = mealId
    }
}


