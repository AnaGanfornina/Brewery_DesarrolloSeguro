//
//  DefaultBreweryRepository.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 20/6/25.
//

import Foundation

// MARK: - BreweryRepository

final class BreweryRepository: BreweryRepositoryProtocol {
    
    private var network: NetworkBreweriesProtocol
    
    init(network: NetworkBreweriesProtocol = NetworkBreweries()) {
        self.network = network
    }
    
    func getBreweries() async -> [Brewery] {
        
        // Comprobar si los datos están en el keychain // TODO: Probar a meterlo en un do catch
        if KeychainHelper.keychain.readBreweryes() == nil{
            
            let data = await network.getBreweries()
        
            KeychainHelper.keychain.saveBreweryes(data.map{ $0.mapToBrewery()})
            
        }
        // Leer los datos de keychain
        guard let savedBreweryes = KeychainHelper.keychain.readBreweryes() else {
            AppLogger.debug("Error: Failed to read data from the Keychain.")
            return []
        }
        return savedBreweryes
    
    }
    /// Función para devolver favoritos
    func getFavoriteBreweries() -> [Brewery] {
        // Comprobar si hay favoritos están en userDefault
        guard let favoritesBreweriesID = EncryptionManager.shared.readFavorites() else {
            AppLogger.debug("Error: Failed to read data from the UserDefault.")
            return []
        }
        
        // Buscar por id de favorito en el keychain
        guard let favoritesBreweries = KeychainHelper.keychain.searchBreweryes(favoritesBreweriesID)else {
            AppLogger.debug("Error: Failed to read data from the Keychain.")
            return []
        }
    
        return favoritesBreweries
    }
    
    func addFavorite(_ brewery: Brewery) {
        EncryptionManager.shared.save(brewery.id)
        
        AppLogger.debug("\(brewery.name) brewery has been added")
    }
    func deleteFavorite(_ brewery: Brewery) {
        EncryptionManager.shared.deleteFavorite(brewery.id)
        AppLogger.debug("\(brewery.name) brewery has been deleted")
    }
}


// MARK: - BreweryRepository Mock

final class BreweryRepositoryMock: BreweryRepositoryProtocol {
    
    private var network: NetworkBreweriesProtocol
    
    init(network: NetworkBreweriesProtocol = NetworkBreweriesMock()) {
        self.network = network
        
    }
    
    func getBreweries() async -> [Brewery] {
        
        // Comprobar si los datos están en el keychain
        if KeychainHelper.keychain.readBreweryes() == nil{
            
            let data = await network.getBreweries()
            KeychainHelper.keychain.saveBreweryes(data.map{ $0.mapToBrewery()})
            
        }
        // Leer los datos de keychain
        guard let savedBreweryes = KeychainHelper.keychain.readBreweryes() else {
            AppLogger.debug("Error: Failed to read data from the Keychain.")
            return []
        }
 
        return savedBreweryes
    }
    func addFavorite(_ brewery: Brewery) {
        
        EncryptionManager.shared.save(brewery.id)

        AppLogger.debug("\(brewery.name) brewery has been added")
     
    }
    
    func deleteFavorite(_ brewery: Brewery) {
        EncryptionManager.shared.deleteFavorite(brewery.id)
        AppLogger.debug("\(brewery.name) brewery has been deleted")
    }
    /// Función para devolver favoritos
    func getFavoriteBreweries() -> [Brewery] {
        let model1 = Brewery(
            id: "701239cb-5319-4d2e-92c1-129ab0b3b440",
            name: "Bière de la Plaine Mock Favorite",
            breweryType: "micro",
            address1: "16 Rue Saint Pierre",
            address2: nil,
            address3: nil,
            city: "Marseille",
            stateProvince: "Bouche du Rhône",
            postalCode: "13006",
            country: "France",
            longitude: 5.38767154,
            latitude: 43.29366192,
            phone: "491473254",
            websiteURL: "https://brasseriedelaplaine.fr/",
            state: "Bouche du Rhône",
            street: "16 Rue Saint Pierre")
        
        let model2 = Brewery(
            id: "ac41870a-13d1-446c-80e4-6cb4570f5fbb",
            name: "La Minotte Mock Favorite",
            breweryType: "micro",
            address1: "14 Blvd de l'Europe",
            address2: nil,
            address3: nil,
            city:"Vitrolles",
            stateProvince: "Bouche du Rhône",
            postalCode: "13127",
            country: "France",
            longitude: 5.24158474,
            latitude: 43.43965026,
            phone: "465948644",
            websiteURL: "https://www.minot-brasserie.fr/",
            state: "Bouche du Rhône",
            street: "14 Blvd de l'Europe")
        
        EncryptionManager.shared.save(model1.id)
        EncryptionManager.shared.save(model2.id)
            
        // Comprobar si hay favoritos están en userDefault
        guard let favoritesBreweriesID = EncryptionManager.shared.readFavorites() else {
            AppLogger.debug("Error: Failed to read data from the Keychain.")
            return []
        }
        
        guard let favoritesBreweries = KeychainHelper.keychain.searchBreweryes(favoritesBreweriesID)else {
            AppLogger.debug("Error: Failed to read data from the Keychain.")
            return []
        }
    
        return favoritesBreweries
    }
    
    
}
