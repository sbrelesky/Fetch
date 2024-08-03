//
//  Ingredient.swift
//  Fetch
//
//  Created by Shane Brelesky on 7/30/24.
//

struct Ingredient: Codable {
    let name: String
    let _measurement: String
    var measurement: String {
        return _measurement
            .replacingOccurrences(of: "tablespoon", with: "tbsp")
            .replacingOccurrences(of: "teaspoon", with: "tsp")
    }
    
    init(name: String, _measurement: String) {
        self.name = name
        self._measurement = _measurement
    }
}
