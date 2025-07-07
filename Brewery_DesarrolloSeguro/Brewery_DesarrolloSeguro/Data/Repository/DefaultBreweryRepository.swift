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
            KeychainHelper.keychain.saveBreweryes(data)
            
        }
        // Leer los datos de keychain
        guard let savedBreweryes = KeychainHelper.keychain.readBreweryes() else {
            AppLogger.debug("Error: Failed to read data from the Keychain.")
            return []
        }
        
        
        return savedBreweryes
    
    }
}


// MARK: - BreweryRepository Mock

final class BreweryRepositoryMock: BreweryRepositoryProtocol {
    
    private var network: NetworkBreweriesProtocol
    
    init(network: NetworkBreweriesProtocol = NetworkBreweriesMock()) {
        self.network = network
    }
    
    func getBreweries() async -> [Brewery] {
        
        // Comprobar si los datos están en el keychain // TODO: Probar a meterlo en un do catch
        if KeychainHelper.keychain.readBreweryes() == nil{
            
            let data = await network.getBreweries()
            KeychainHelper.keychain.saveBreweryes(data)
            
        }
        // Leer los datos de keychain
        guard let savedBreweryes = KeychainHelper.keychain.readBreweryes() else {
            AppLogger.debug("Error: Failed to read data from the Keychain.")
            return []
        }
        
        
        return savedBreweryes
    
    }
}
