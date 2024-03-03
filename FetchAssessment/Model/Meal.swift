//
//  Meal.swift
//  FetchAssessment
//
//  Created by ashika kalmady on 2/27/24.
//

import Foundation

public struct MealsResponse: Codable {
    let meals: [Meal]
}

/// Represents detailed information about a meal, including ingredients and preparation instructions.
public struct Meal: Codable, Identifiable {
    let name: String
    public let id: String
    
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
        // Explicit coding keys for ingredients and measurements are not needed
    }
    
    public init(from decoder: Decoder) throws {
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
        
        // Manually decode ingredients and measurements
        let baseContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        ingredientsWithMeasurements = (1...20).compactMap { index in
            let ingredientKey = DynamicCodingKeys(stringValue: "strIngredient\(index)")
            let measurementKey = DynamicCodingKeys(stringValue: "strMeasure\(index)")
            
            guard let ingredientKey = ingredientKey, let measurementKey = measurementKey,
                  let ingredient = try? baseContainer.decodeIfPresent(String.self, forKey: ingredientKey),
                  let measurement = try? baseContainer.decodeIfPresent(String.self, forKey: measurementKey),
                  !ingredient.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }
            return "\(ingredient): \(measurement)"
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


extension Meal {
    // Formats ingredients and measurements into a single string for each ingredient with its measurement.
    var formattedIngredients: [String] {
        var ingredientsList: [String] = []
        let mirror = Mirror(reflecting: self)
        
        for child in mirror.children {
            if let label = child.label, label.starts(with: "strIngredient"), let ingredient = child.value as? String, !ingredient.isEmpty {
                let index = label.dropFirst("strIngredient".count)
                if let measure = mirror.descendant("strMeasure\(index)") as? String, !measure.isEmpty {
                    ingredientsList.append("\(ingredient): \(measure)")
                }
            }
        }
        return ingredientsList
    }
}
