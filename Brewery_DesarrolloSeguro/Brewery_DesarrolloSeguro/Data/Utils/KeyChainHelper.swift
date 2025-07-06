//
//  KeyChainHelper.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 5/7/25.
//

import Foundation


final class KeychainHelper {
    
    static let keychain = KeychainHelper()
    
    private init() {}
// TODO: - Revisar
    
    // MARK: - Brewery functions
    
    func saveBreweryes(_ breweryes: [Brewery]){
        guard let breweryesData = try? JSONEncoder().encode(breweryes) else {
            print("Error: could not convert breweryes to Data")
            return
        }
        
        save(data: breweryesData, account: "Breweryes")
        AppLogger.debug("Breweryes saved to keychain")
        
    }
    
    func readBreweryes() -> [Brewery]?{
        guard let breweryesData = read(account: "Breweryes") else {
            print("Error: could not read Breweryes from keychain")
            return nil
        }
        
        guard let breweryes = try? JSONDecoder().decode([Brewery].self, from: breweryesData) else {
            return nil
        }
        return breweryes
    }
    
    func deleteBrewery(){
        delete(account: "Breweryes")
    }
    
    // MARK: - Favorites functions
    
    func saveFavoritesBreweryes(_ favorite: [Brewery]){
        guard let favoriteData = try? JSONEncoder().encode(favorite) else {
            print("Error: could not convert favorite to Data")
            return
        }
        
        save(data: favoriteData, account: "favoriteBrewery")
        
    }
    
    func readFavoritseBreweryes() -> [Brewery]?{
        guard let favoriteData = read(account: "favoriteBrewery") else {
            print("Error: could not read favorites Breweryes from keychain")
            return nil
        }
        
        guard let favoriteBreweryes = try? JSONDecoder().decode([Brewery].self, from: favoriteData) else {
            return nil
        }
        return favoriteBreweryes
    }
    
    func deleteFavoriteBrewery(){
        delete(account: "favoriteBrewery")
    }
    
    
    
    // Save data
    private func save(data: Data, service: String = "AGBrewery", account: String) {
        // Crear la query
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        

        // errSecDuplicateltem -> actualizar
        if status == errSecDuplicateItem {
            // Crear la query para actualizar el item
            let queryToUpdate = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: service,
                kSecAttrAccount: account
            ] as CFDictionary
            
            let attributesToUpdate = [kSecValueData: data] as CFDictionary
            
            SecItemUpdate(queryToUpdate, attributesToUpdate)
        } else if status != errSecSuccess { // errSecSuccess
            print("Error: error adding item")
        }
    }
        
    // Read data
    private func read(service: String = "AGBrewery", account: String) -> Data? {
        // Crear la query
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result) // TODO: Tratar posibles errores de autentificación con faceID
        
        guard let dataResult = result as? Data else {
            print("Error: error converted data")
            return nil
        }
        
        return dataResult
    }
    
    // Delete data
    private func delete(service: String = "AGBrewery", account: String) {
        
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
        ] as CFDictionary
        
        let status = SecItemDelete(query)
        AppLogger.debug("Se han borrado los datos. Status:\(status)")
    }
    
}
