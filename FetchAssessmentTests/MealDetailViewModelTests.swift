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
    var viewModel: MealDetailViewModel!
    var mockAPIClient: MockAPIClient!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        mockAPIClient = MockAPIClient()
        viewModel = MealDetailViewModel(apiClient: mockAPIClient)
        cancellables = []
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        mockAPIClient = nil
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
                 "strInstructions": "Heat oven to 190C/170C fan/gas 5. Tip the flour and sugar into a large bowl. Add the butter, then rub into the flour using your fingertips to make a light breadcrumb texture. Do not overwork it or the crumble will become heavy. Sprinkle the mixture evenly over a baking sheet and bake for 15 mins or until lightly coloured.\r\nMeanwhile, for the compote, peel, core and cut the apples into 2cm dice. Put the butter and sugar in a medium saucepan and melt together over a medium heat. Cook for 3 mins until the mixture turns to a light caramel. Stir in the apples and cook for 3 mins. Add the blackberries and cinnamon, and cook for 3 mins more. Cover, remove from the heat, then leave for 2-3 mins to continue cooking in the warmth of the pan.\r\nTo serve, spoon the warm fruit into an ovenproof gratin dish, top with the crumble mix, then reheat in the oven for 5-10 mins. Serve with vanilla ice cream.",
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
    
}
