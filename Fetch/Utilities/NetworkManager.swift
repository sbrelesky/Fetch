//
//  NetworkManager.swift
//  Fetch
//
//  Created by Shane Brelesky on 7/30/24.
//

import Foundation
import UIKit

protocol NetworkManagerProtocol {
    func fetchMeals() async throws -> [Meal]
    func fetchMealDetails(for id: String) async throws -> [MealDetails]
}

class NetworkManager: NetworkManagerProtocol {
    
    private let baseUrl = "https://themealdb.com/api/json/v1/1"

    func fetchMeals() async throws -> [Meal] {
       
        let urlString = "\(baseUrl)/filter.php?c=Dessert"
        guard let url = URL(string: urlString) else {
            throw NetworkError.badURL
        }
        
        let mealResponse = try await fetchData(from: url, responseType: Response<Meal>.self)
        return mealResponse.meals.sorted(by: { $0.name < $1.name })
    }

    func fetchMealDetails(for id: String) async throws -> [MealDetails] {
        
        let urlString = "\(baseUrl)/lookup.php?i=\(id)"
        guard let url = URL(string: urlString) else {
            throw NetworkError.badURL
        }
        
        let mealDetails =  try await fetchData(from: url, responseType: Response<MealDetails>.self)
        return mealDetails.meals
    }
    
    private func fetchData<T: Decodable>(from url: URL, responseType: T.Type) async throws -> T {

        guard url.scheme != nil && url.host != nil else {
            throw NetworkError.badURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.requestFailed
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                return decodedResponse
            } catch {
                print(error)
                throw NetworkError.decodingFailed
            }
            
        } catch {
            throw NetworkError.requestFailed
        }
    }
}


