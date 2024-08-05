//
//  String.swift
//  Fetch
//
//  Created by Shane Brelesky on 8/5/24.
//

extension String {
    func cleanFractionForString() -> String {
        return self
            .replacingOccurrences(of: "1/8", with: "\u{215B}")
            .replacingOccurrences(of: "1/4", with: "\u{00BC}")
            .replacingOccurrences(of: "1/3", with: "\u{2153}")
            .replacingOccurrences(of: "1/2", with: "\u{00BD}")
            .replacingOccurrences(of: "2/3", with: "\u{2154}")
            .replacingOccurrences(of: "3/4", with: "\u{00BE}")
            .replacingOccurrences(of: "3/8", with: "\u{215C}")
            .replacingOccurrences(of: "5/8", with: "\u{215D}")
            .replacingOccurrences(of: "7/8", with: "\u{215E}")
    }
    
    func cleanAbbreviations() -> String {
        return self
            .replacingOccurrences(of: "tablespoon", with: "tbsp")
            .replacingOccurrences(of: "tbls", with: "tbsp")
            .replacingOccurrences(of: "tblsp", with: "tbsp")
            .replacingOccurrences(of: "tbs", with: "tbsp")
            .replacingOccurrences(of: "teaspoon", with: "tsp")
            .replacingOccurrences(of: "tspn", with: "tsp")

    }
}
