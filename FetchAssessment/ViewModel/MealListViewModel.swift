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

/// A ViewModel for managing the state and data of a list of meals.
///
/// Conforms to `MealListViewModelProtocol` for fetching meals and `ViewModelStateProtocol` to reflect the fetch state.
class MealListViewModel: MealListViewModelProtocol, ViewModelStateProtocol, ObservableObject {
    
    /// An array of `Meal` objects that the view model holds.
    @Published var meals: [Meal] = []
    
    /// Represents the current state of the ViewModel with respect to data fetching and presentation.
    /// The state is observable and can be used to update the UI accordingly.
    @Published private(set) var state: ViewModelState<[Meal]> = .idle
    
    /// Stores subscriptions to prevent them from being deallocated prematurely.
    private var cancellables = Set<AnyCancellable>()
    
    /// The API client used for making network requests. Allows for dependency injection for easier testing.
    private let apiClient: APIClient
    
    /// The category of meals to fetch. Default is "Dessert".
    private var category: String
    
    /// Fetches the meals from the API based on the specified category and updates the ViewModel's state and meals list.
    ///
    /// It sets the state to `.loading` before making the fetch request. Upon receiving a response, it updates
    /// the meals list and changes the state to either `.loaded` with the fetched meals, `.empty` if no meals were fetched,
    /// or `.failed` with an error message if an error occurred.
    func fetchMeals() {
        self.state = .loading
        let request = MealRequest(listForCategory: category)
        
        apiClient.performRequest(request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.state = .failed("Failed to fetch meal details: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] (response: MealsResponse) in
                let sortedMeals = response.meals.sorted { $0.name < $1.name }
                self?.meals = sortedMeals
                self?.state = sortedMeals.isEmpty ? .empty : .loaded(sortedMeals)
            })
            .store(in: &cancellables)
    }
    
    /// Initializes the ViewModel with an `APIClient` and a meal category.
    /// - Parameters:
    ///   - apiClient: The API client to use for network requests. Defaults to `URLSessionAPIClient`.
    ///   - category: The category of meals to fetch. Defaults to "Dessert".
    init(apiClient: APIClient = URLSessionAPIClient(), category: String = "Dessert") {
        self.apiClient = apiClient
        self.category = category
    }
}
