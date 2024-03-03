//
//  MealDetailViewModelTests.swift
//  FetchAssessmentTests
//
//  Created by ashika kalmady on 2/28/24.
//

import XCTest
import Combine
@testable import FetchAssessment

final class MealDetailViewModelTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
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
    
    func testFetchMealDetailSuccess() {
        // Prepare mock response
        let jsonData = """
           {
             "meals": [
               {
                 "idMeal": "52893",
                 "strMeal": "Apple & Blackberry Crumble",
                 "strDrinkAlternate": null,
                 "strCategory": "Dessert",
                 "strArea": "British",
                 "strInstructions": "Heat oven to 190C/170C fan/gas 5. Tip the flour and sugar into a large bowl. Add the butter, then rub into the flour using your fingertips to make a light breadcrumb texture. Do not overwork it or the crumble will become heavy. Sprinkle the mixture evenly over a baking sheet and bake for 15 mins or until lightly coloured.",
                 "strMealThumb": "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg",
                 "strTags": "Pudding",
                 "strYoutube": "https://www.youtube.com/watch?v=4vhcOwVBDO4",
                 "strIngredient1": "Plain Flour",
                 "strIngredient2": "Caster Sugar",
                 "strIngredient3": "Butter",
                 "strIngredient4": "Braeburn Apples",
                 "strIngredient5": "Butter",
                 "strIngredient6": "Demerara Sugar",
                 "strIngredient7": "Blackberrys",
                 "strIngredient8": "Cinnamon",
                 "strIngredient9": "Ice Cream",
                 "strIngredient10": "",
                 "strIngredient11": "",
                 "strIngredient12": "",
                 "strIngredient13": "",
                 "strIngredient14": "",
                 "strIngredient15": "",
                 "strIngredient16": "",
                 "strIngredient17": "",
                 "strIngredient18": "",
                 "strIngredient19": "",
                 "strIngredient20": "",
                 "strMeasure1": "120g",
                 "strMeasure2": "60g",
                 "strMeasure3": "60g",
                 "strMeasure4": "300g",
                 "strMeasure5": "30g",
                 "strMeasure6": "30g",
                 "strMeasure7": "120g",
                 "strMeasure8": "¼ teaspoon",
                 "strMeasure9": "to serve",
                 "strMeasure10": "",
                 "strMeasure11": "",
                 "strMeasure12": "",
                 "strMeasure13": "",
                 "strMeasure14": "",
                 "strMeasure15": "",
                 "strMeasure16": "",
                 "strMeasure17": "",
                 "strMeasure18": "",
                 "strMeasure19": "",
                 "strMeasure20": "",
                 "strSource": "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
                 "strImageSource": null,
                 "strCreativeCommonsConfirmed": null,
                 "dateModified": null
               }
             ]
           }
           """.data(using: .utf8)!
        let mockAPIClient: MockAPIClient = MockAPIClient()
        let viewModel: MealDetailViewModel = MealDetailViewModel(apiClient: mockAPIClient, mealId: "52893")
        
        mockAPIClient.result = .success(jsonData)
        
        let expectation = XCTestExpectation(description: "MealDetail fetched and parsed")
        
        viewModel.$mealDetail
            .dropFirst() // Ignore initial value
            .sink { mealDetail in
                XCTAssertNotNil(mealDetail)
                XCTAssertEqual(mealDetail?.id, "52893")
                XCTAssertEqual(mealDetail?.name, "Apple & Blackberry Crumble")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchMealDetail()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchMealDetailFailure() throws {
        // Create an instance of your mock API client
        let mockAPIClient = MockAPIClient()
        
        // Initialize your view model with the mock API client
        let viewModel = MealDetailViewModel(apiClient: mockAPIClient, mealId: "invalid")
        mockAPIClient.result = .failure(APIError.noResponse)
        let expectation = self.expectation(description: "Fetch meal detail failure")
        
        // When
        viewModel.fetchMealDetail()
        
        // Then
        viewModel.$state
            .dropFirst()
            .sink { state in
                if case .failed(let errorMessage) = state {
                    XCTAssertNotNil(errorMessage) // Ensure there is an error message
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
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
        let viewModel = MealDetailViewModel(apiClient: mockAPIClient, mealId: "65432")

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
        viewModel.fetchMealDetail()

        // Wait for the expectations to be fulfilled
        wait(for: [expectation], timeout: 1.0)
    }
    
}
