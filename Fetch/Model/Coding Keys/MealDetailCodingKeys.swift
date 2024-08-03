//
//  MealDetailCodingKeys.swift
//  Fetch
//
//  Created by Shane Brelesky on 7/30/24.
//

enum MealDetailCodingKeys: String, CodingKey {
    case id = "idMeal"
    case name = "strMeal"
    case imageUrl = "strMealThumb"
    case origin = "strArea"
    case instructions = "strInstructions"
    case drink = "strDrinkAlternate"
    case tags = "strTags"
    case youtubeUrl = "strYoutube"
    case sourceUrl = "strSource"
}
