//
//  DessertDetail.swift
//  Fetch
//
//  Created by Shane Brelesky on 7/30/24.
//

struct MealDetails: Codable {
    
    let id: String
    let name: String
    let imageUrl: String
    let origin: String
    let drink: String?
    private let _instructions: String
    let tags: String?
    let youtubeUrl: String
    let sourceUrl: String?
    let ingredients: [Ingredient]
    
    var instructions: String {
        return _instructions
            .replacingOccurrences(of: "\r", with: "\n")
            .replacingOccurrences(of: "\n\n\n\n", with: "\n\n")
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: MealDetailCodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.imageUrl = try container.decode(String.self, forKey: .imageUrl)
        self.origin = try container.decode(String.self, forKey: .origin)
        self._instructions = try container.decode(String.self, forKey: .instructions)
        self.drink = try container.decodeIfPresent(String.self, forKey: .drink)
        self.tags = try container.decodeIfPresent(String.self, forKey: .tags)
        self.youtubeUrl = try container.decode(String.self, forKey: .youtubeUrl)
        self.sourceUrl = try container.decodeIfPresent(String.self, forKey: .sourceUrl)
        self.ingredients = try MealDetails.parseIngredients(from: decoder)
    }
    
    private static func parseIngredients(from decoder: Decoder) throws -> [Ingredient] {
        var ingredients: [Ingredient] = []
        
        let ingredientContainer = try decoder.container(keyedBy: IngredientKeys.self)
        let measurementContainer = try decoder.container(keyedBy: MeasurementKeys.self)
 
        /// Would probably want to make this dynamic in a real-world application
        /// Get a maxIngredients count returned as part of the json or count the number of occurences of the substring 'strIngredient'
        for i in 1...20 {
            
            guard let ingredientNameKey = IngredientKeys(stringValue: "strIngredient\(i)"),
                  let measurementKey = MeasurementKeys(stringValue: "strMeasure\(i)"),
                  let ingredientName = try ingredientContainer.decodeIfPresent(String.self, forKey: ingredientNameKey),
                  let measurement = try measurementContainer.decodeIfPresent(String.self, forKey: measurementKey),
                  ingredientName != "", measurement != "" else {
                continue
            }
            
            if !ingredients.contains(where: { $0.name == ingredientName }) {
                let ingredient = Ingredient(
                    name: ingredientName.capitalized,
                    measurement: Measurement(measurementString: measurement)
                )
                ingredients.append(ingredient)
            }
        }
        
        return ingredients
    }
}
