//
//  Repsonse.swift
//  Fetch
//
//  Created by Shane Brelesky on 8/3/24.
//

struct Response<T: Codable>: Codable {
    let meals: [T]
}
