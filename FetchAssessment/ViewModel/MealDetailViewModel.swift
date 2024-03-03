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

/// A ViewModel for managing the state and data of meal detail.
///
/// Conforms to `MealDetailViewModelProtocol` for fetching meal details and `ViewModelStateProtocol` to reflect the fetch state.
class MealDetailViewModel: MealDetailViewModelProtocol, ViewModelStateProtocol, ObservableObject {
    
    /// Holds the detailed information about a meal. It's `nil` until data is fetched successfully.
    @Published var mealDetail: Meal?
    
    /// Represents the current state of the ViewModel with respect to data fetching and presentation.
    /// The state is observable and can be used to update the UI accordingly.
    @Published private(set) var state: ViewModelState<Meal> = .idle
    
    /// Stores subscriptions to prevent them from being deallocated prematurely.
    private var cancellables = Set<AnyCancellable>()
    
    /// The API client used for making network requests. Allows for dependency injection for easier testing.
    private let apiClient: APIClient
    
    /// The unique identifier of the meal to fetch details for.
    private let mealId: String
    
    /// Fetches the details for a meal identified by `mealId` and updates the ViewModel's state and `mealDetail`.
    ///
    /// It sets the state to `.loading` before making the fetch request. Upon receiving a response, it updates
    /// `mealDetail` and changes the state to either `.loaded` with the fetched meal, `.empty` if no meal was fetched,
    /// or `.failed` with an error message if an error occurred.
    func fetchMealDetail() {
        self.state = .loading
        let request = MealRequest(detailForMealId: mealId)
        
        apiClient.performRequest(request)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.state = .failed("Failed to fetch meal details: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] (response: MealsResponse) in
                guard let mealDetail = response.meals.first else {
                    self?.state = .empty
                    return
                }
                
                self?.mealDetail = mealDetail
                self?.state = .loaded(mealDetail)
            })
            .store(in: &cancellables)
    }
    
    /// Initializes the ViewModel with an `APIClient` instance and a meal ID.
    /// - Parameters:
    ///   - apiClient: The API client to use for network requests.
    ///   - mealId: The unique identifier of the meal for which to fetch details.
    init(apiClient: APIClient, mealId: String) {
        self.apiClient = apiClient
        self.mealId = mealId
    }
}



