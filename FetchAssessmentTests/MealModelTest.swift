//
//  MealModelTest.swift
//  FetchAssessmentTests
//
//  Created by ashika kalmady on 3/3/24.
//

import XCTest
@testable import FetchAssessment

final class MealModelTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
    
    func testMealDecoding() throws {
        
        let completeMealJSON = """
        {
            "idMeal": "52771",
            "strMeal": "Spaghetti Carbonara",
            "strCategory": "Italian",
            "strArea": "Italy",
            "strInstructions": "Cook pasta. Mix eggs and cheese. Combine with pasta.",
            "strMealThumb": "https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg",
            "strTags": "Pasta,Italy",
            "strYoutube": "https://www.youtube.com/watch?v=4vhcOwVBDO4",
            "strIngredient1": "Spaghetti",
            "strMeasure1": "400g",
            "strSource": "https://www.example.com",
            "strImageSource": "https://www.example.com/image.jpg",
            "strCreativeCommonsConfirmed": "Yes",
            "dateModified": "2019-08-24"
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let meal = try decoder.decode(Meal.self, from: completeMealJSON)
        
        XCTAssertEqual(meal.id, "52771")
        XCTAssertEqual(meal.name, "Spaghetti Carbonara")
        XCTAssertEqual(meal.category, "Italian")
        XCTAssertEqual(meal.area, "Italy")
        XCTAssertEqual(meal.instructions, "Cook pasta. Mix eggs and cheese. Combine with pasta.")
        XCTAssertEqual(meal.thumbnailURL, "https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg")
        XCTAssertEqual(meal.tags, "Pasta,Italy")
        XCTAssertEqual(meal.youtubeURL, "https://www.youtube.com/watch?v=4vhcOwVBDO4")
        XCTAssertEqual(meal.sourceURL, "https://www.example.com")
        XCTAssertEqual(meal.imageSourceURL, "https://www.example.com/image.jpg")
        XCTAssertEqual(meal.creativeCommonsConfirmed, "Yes")
        XCTAssertEqual(meal.dateModified, "2019-08-24")
        XCTAssertEqual(meal.ingredientsWithMeasurements, ["Spaghetti: 400g"])
    }
    
    func testMealDecodingWithMissingFields() throws {
        let partialMealJSON = """
        {
            "idMeal": "52772",
            "strMeal": "Pasta",
            "strIngredient1": "Pasta",
            "strMeasure1": "200g"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let meal = try decoder.decode(Meal.self, from: partialMealJSON)
        
        XCTAssertEqual(meal.id, "52772")
        XCTAssertEqual(meal.name, "Pasta")
        XCTAssertNil(meal.category)
        XCTAssertNil(meal.area)
        XCTAssertEqual(meal.ingredientsWithMeasurements, ["Pasta: 200g"])
    }

}
