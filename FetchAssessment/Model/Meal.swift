//
//  Meal.swift
//  FetchAssessment
//
//  Created by ashika kalmady on 2/27/24.
//

import Foundation

struct MealsResponse: Codable {
    let meals: [Meal]
}

/// Represents detailed information about a meal, including ingredients and preparation instructions.
struct Meal: Codable, Identifiable {
    let name: String
    let id: String
    
    let category: String?
    let area: String?
    let instructions: String?
    let thumbnailURL: String?
    let tags: String?
    let youtubeURL: String?
    let alternateDrink: String?
    let sourceURL: String?
    let imageSourceURL: String?
    let creativeCommonsConfirmed: String?
    let dateModified: String?
    
    var ingredientsWithMeasurements: [String] = []
    
    enum CodingKeys: String, CodingKey {
        case name = "strMeal", id = "idMeal", category = "strCategory", area = "strArea", instructions = "strInstructions"
        case thumbnailURL = "strMealThumb", tags = "strTags", youtubeURL = "strYoutube", alternateDrink = "strDrinkAlternate"
        case sourceURL = "strSource", imageSourceURL = "strImageSource", creativeCommonsConfirmed = "strCreativeCommonsConfirmed", dateModified = "dateModified"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        id = try container.decode(String.self, forKey: .id)
        category = try container.decodeIfPresent(String.self, forKey: .category)
        area = try container.decodeIfPresent(String.self, forKey: .area)
        instructions = try container.decodeIfPresent(String.self, forKey: .instructions)
        thumbnailURL = try container.decodeIfPresent(String.self, forKey: .thumbnailURL)
        tags = try container.decodeIfPresent(String.self, forKey: .tags)
        youtubeURL = try container.decodeIfPresent(String.self, forKey: .youtubeURL)
        alternateDrink = try container.decodeIfPresent(String.self, forKey: .alternateDrink)
        sourceURL = try container.decodeIfPresent(String.self, forKey: .sourceURL)
        imageSourceURL = try container.decodeIfPresent(String.self, forKey: .imageSourceURL)
        creativeCommonsConfirmed = try container.decodeIfPresent(String.self, forKey: .creativeCommonsConfirmed)
        dateModified = try container.decodeIfPresent(String.self, forKey: .dateModified)
        
        let dynamicContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        
        // Dynamically determine the number of ingredients and measurements
        let ingredientKeys = dynamicContainer.allKeys.filter { $0.stringValue.starts(with: "strIngredient") && !($0.stringValue.dropFirst("strIngredient".count).isEmpty) }
        let measurementKeys = dynamicContainer.allKeys.filter { $0.stringValue.starts(with: "strMeasure") && !($0.stringValue.dropFirst("strMeasure".count).isEmpty) }
        
        
        for ingredientKey in ingredientKeys {
             let indexString = ingredientKey.stringValue.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
               if let index = Int(indexString),
               let measureKey = DynamicCodingKeys(stringValue: "strMeasure\(index)"),
               let ingredient = try dynamicContainer.decodeIfPresent(String.self, forKey: ingredientKey)?.trimmingCharacters(in: .whitespacesAndNewlines),
               !ingredient.isEmpty,
               let measurement = try dynamicContainer.decodeIfPresent(String.self, forKey: measureKey)?.trimmingCharacters(in: .whitespacesAndNewlines) {
                ingredientsWithMeasurements.append("\(ingredient): \(measurement)")
            }
        }
    }
    
    private struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int?
        
        init?(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = nil
        }
        
        init?(intValue: Int) {
            self.stringValue = String(intValue)
            self.intValue = intValue
        }
    }
}
