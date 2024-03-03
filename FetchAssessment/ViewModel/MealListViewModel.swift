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

class MealListViewModel: MealListViewModelProtocol, ObservableObject {
    @Published var meals: [Meal] = []
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    private let apiClient: APIClient
    private var category: String = "Dessert"
    
    func fetchMeals() {
        isLoading = true
        let request = MealRequest(listForCategory: category)
        
        apiClient.performRequest(request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
            }, receiveValue: { [weak self] (response: MealsResponse) in
                self?.meals = response.meals.sorted { $0.name < $1.name }
            })
            .store(in: &cancellables)
    }
    
    // initializer to accept an APIClient instance and category
    init(apiClient: APIClient, category: String = "Dessert") {
        self.apiClient = apiClient
        self.category = category
    }
}
