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
    // MARK: CodingKeys
    /// `CodingKeys` enum defines the keys used by the `Decoder` to match the JSON keys with the properties of the `Meal` struct.
    enum CodingKeys: String, CodingKey {
        case name = "strMeal", id = "idMeal", category = "strCategory", area = "strArea", instructions = "strInstructions"
        case thumbnailURL = "strMealThumb", tags = "strTags", youtubeURL = "strYoutube", alternateDrink = "strDrinkAlternate"
        case sourceURL = "strSource", imageSourceURL = "strImageSource", creativeCommonsConfirmed = "strCreativeCommonsConfirmed", dateModified = "dateModified"
    }
    
    // MARK: Initializer
    /// Custom initializer to decode a `Meal` instance from a decoder.
    /// It manually decodes each property and dynamically decodes ingredients and their measurements to handle variable numbers of ingredients.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Standard decoding for non-dynamic properties
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
        
        // Dynamic decoding for ingredients and measurements
        let dynamicContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        
        // Dynamically determine the number of ingredients and measurements
        let ingredientKeys = dynamicContainer.allKeys.filter { $0.stringValue.starts(with: "strIngredient") && !($0.stringValue.dropFirst("strIngredient".count).isEmpty) }
        let measurementKeys = dynamicContainer.allKeys.filter { $0.stringValue.starts(with: "strMeasure") && !($0.stringValue.dropFirst("strMeasure".count).isEmpty) }
        
        // Filtering and decoding ingredients and measurements by dynamically constructed keys.
        // This approach handles variable numbers of ingredients and measurements without hardcoding.
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
    
    // MARK: DynamicCodingKeys
    /// `DynamicCodingKeys` struct allows for the dynamic decoding of keys based on their string value or integer value.
    /// This is used to decode the varying number of ingredients and measurements.
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
