//
//  MealListViewModel.swift
//  FetchAssessment
//
//  Created by ashika kalmady on 2/27/24.
//

import Foundation
import Combine

protocol MealListViewModelProtocol: ObservableObject {
    var meals: [Meal] { get set }
    func fetchMeals()
}

class MealListViewModel: MealListViewModelProtocol, ViewModelStateProtocol, ObservableObject {
    @Published var meals: [Meal] = []
    @Published private(set) var state: ViewModelState<[Meal]> = .idle
    private var cancellables = Set<AnyCancellable>()
    private let apiClient: APIClient
    private var category: String
    
    // Fetch the meal list from the api and update the UI
    func fetchMeals() {
        self.state = .loading
        let request = MealRequest(listForCategory: category)
        
        apiClient.performRequest(request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    // If there's an error, update the state to reflect the failure.
                    self?.state = .failed("Failed to fetch meal details: \(error.localizedDescription)")
                case .finished:
                    // No action needed for the .finished case at the moment.
                    break
                }
            }, receiveValue: { [weak self] (response: MealsResponse) in
                let sortedMeals = response.meals.sorted { $0.name < $1.name }
                self?.meals = sortedMeals
                
                // If sortedMeals is empty, set state to .empty, otherwise to .loaded with the sorted meals.
                self?.state = sortedMeals.isEmpty ? .empty : .loaded(sortedMeals)
            })
            .store(in: &cancellables)
    }
    
    // initializer to accept an APIClient instance and category
    init(apiClient: APIClient = URLSessionAPIClient(), category: String = "Dessert") {
        self.apiClient = apiClient
        self.category = category
    }
}
