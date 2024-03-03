//
//  MealDetail.swift
//  FetchAssessment
//
//  Created by ashika kalmady on 2/27/24.
//

import Foundation

struct MealList: Codable {
    let meals: [Meal]
}

struct Meal: Codable {
    let strMeal: String
    let strMealThumb: URL
    let idMeal: String
    
    var id: String { idMeal }
}


struct MealDetail: Codable {
    let idMeal: String
    let strMeal: String
    let strCategory: String?
    let strArea: String?
    let strInstructions: String
    let strMealThumb: URL
    let strTags: String?
    let strYoutube: URL?
    // Ingredients and measures are simplified for the example
    let strIngredient1: String?
    let strMeasure1: String?
    // Add the rest of the ingredients and measures as needed
}
