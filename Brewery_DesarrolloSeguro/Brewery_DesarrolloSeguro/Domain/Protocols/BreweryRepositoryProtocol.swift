//
//  BreweryRepositoryProtocol.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 20/6/25.
//

import Foundation

protocol BreweryRepositoryProtocol {
    func getBreweries() async -> [Brewery]
    func addFavorite(_ brewery: Brewery) 
    func getFavoriteBreweries() -> [String] 
}
