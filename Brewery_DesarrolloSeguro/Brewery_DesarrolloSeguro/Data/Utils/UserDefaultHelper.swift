//
//  UserDefaultHelper.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 12/7/25.
//

import Foundation

final class UserDefaultsHelper {
    
    // MARK: - Properties
    static let defaults = UserDefaultsHelper()
    
    // MARK: - Functions
    private init() {}
    
    func save(_ favoriteID : String) {
        var favorites = UserDefaults.standard.array(forKey: "favorites") as? [String] ?? []
        favorites.append(favoriteID)
           UserDefaults.standard.set(favorites, forKey: "favorites")
    }
    func readFavorites() -> [String]? {
        return UserDefaults.standard.stringArray(forKey: "favorites")
    }
    
    func deleteFavorite(_ favorite: String) {
        var favorites = UserDefaults.standard.stringArray(forKey: "favorites") ?? []
        favorites.removeAll { $0 == favorite }
        UserDefaults.standard.set(favorites, forKey: "favorites")
    }
}
