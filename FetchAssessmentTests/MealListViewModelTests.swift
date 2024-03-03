//
//  MealListViewModelTests.swift
//  FetchAssessmentTests
//
//  Created by ashika kalmady on 3/3/24.
//

import XCTest
import Combine
@testable import FetchAssessment

final class MealListViewModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        cancellables = []
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        cancellables = nil
        super.tearDown()
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFetchMealsSuccess() {
        let mockAPIClient = MockAPIClient()
        // Initialize your view model with the mock API client
        let viewModel = MealListViewModel(apiClient: mockAPIClient)
        
        // Prepare the mock response
        let mealData = """
            {
                "meals": [
                    {
                        "idMeal": "52771",
                        "strMeal": "Spaghetti Carbonara",
                        "strMealThumb": "https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg"
                    }
                ]
            }
            """.data(using: .utf8)!
        mockAPIClient.result = .success(mealData)
        
        let expectation = XCTestExpectation(description: "Successfully fetch meals")
        
        // Observe the meals property for changes
        viewModel.$meals
            .dropFirst()
            .sink { meals in
                XCTAssertFalse(meals.isEmpty)
                XCTAssertEqual(meals.first?.id, "52771")
                XCTAssertEqual(meals.first?.name, "Spaghetti Carbonara")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        // Trigger the fetch operation
        viewModel.fetchMeals()
        
        // Wait for the expectations to be fulfilled
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchMealsEmptyState() throws {
        // Create an instance of your mock API client
        let mockAPIClient = MockAPIClient()

        // Simulate an empty data response
        let mealEmptyData = """
        {
            "meals": []
        }
        """.data(using: .utf8)!
        mockAPIClient.result = .success(mealEmptyData)

        // Initialize your view model with the mock API client
        let viewModel = MealListViewModel(apiClient: mockAPIClient)

        // Set up an expectation for the asynchronous operation
        let expectation = XCTestExpectation(description: "Expecting the state to become .empty")

        // Observe the state property for changes
        viewModel.$state
            .dropFirst() // Skip the initial value
            .sink { state in
                if case .empty = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        // Trigger the fetch operation
        viewModel.fetchMeals()

        // Wait for the expectations to be fulfilled
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchMealsFailureState() throws {
        // Create an instance of your mock API client
        let mockAPIClient = MockAPIClient()

        // Simulate a failure response
        mockAPIClient.result = .failure(APIError.statusCodeNotOk)

        // Initialize your view model with the mock API client
        let viewModel = MealListViewModel(apiClient: mockAPIClient)

        // Set up an expectation for the asynchronous operation
        let expectation = XCTestExpectation(description: "Expecting the state to become .failed with an error message")

        // Observe the state property for changes
        viewModel.$state
            .dropFirst() // Skip the initial value
            .sink { state in
                if case .failed(let errorMessage) = state {
                    XCTAssertNotNil(errorMessage) // Ensure there is an error message
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        // Trigger the fetch operation
        viewModel.fetchMeals()

        // Wait for the expectations to be fulfilled
        wait(for: [expectation], timeout: 1.0)
    }


}
