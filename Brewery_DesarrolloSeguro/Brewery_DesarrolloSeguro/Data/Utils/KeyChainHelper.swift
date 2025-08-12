//
//  KeyChainHelper.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 5/7/25.
//

import Foundation
import CryptoKit


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
            AppLogger.debug("Error: could not read Breweryes from keychain")
            return nil
        }

        guard let breweryes = try? JSONDecoder().decode([Brewery].self, from: breweryesData) else {
            return nil
        }
        return breweryes
        
    }
    
    func searchBreweryes(_ favorites: [String]) -> [Brewery]?{
        
        guard let breweryesData = self.readBreweryes() else {
            return nil
        }
        let favoritesFiltered = breweryesData.filter { favorites.contains($0.id) }
        
        
        return favoritesFiltered
    }
    
    func deleteBrewery(){
        delete(account: "Breweryes")
    }
    
    // MARK: - Key function
    func saveKey(_ key: SymmetricKey){
        
        let keyData: Data = key.withUnsafeBytes { bytes in
            return Data(bytes)
        }
        save(data: keyData, account: "Key")
    }
    
    func readKey() -> SymmetricKey?{
        guard let keyData = read(account: "Key") else {
            return nil
        }
        return SymmetricKey(data: keyData)
    }
    
    func deleteKey(){
        delete(account: "Key")
    }
    
    
    // MARK: - Save data Keychain
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
            AppLogger.debug("Error: error converted data")
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
    
    // MARK: - Save key Keychain
    private func saveKey(data: SymmetricKey, service: String = "AGBrewery", account: String) {
        // Crear la query
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassKey,
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
    private func readKey(service: String = "AGBrewery", account: String) -> SymmetricKey? {
        // Crear la query
        let query = [
            kSecClass: kSecClassKey,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result) // TODO: Tratar posibles errores de autentificación con faceID
        
        guard let dataResult = result as? SymmetricKey else {
            print("Error: error converted SymmetricKey")
            return nil
        }
        
        return dataResult
    }
    
    // Delete data
    private func deleteKey(service: String = "AGBrewery", account: String) {
        
        let query = [
            kSecClass: kSecClassKey,
            kSecAttrService: service,
            kSecAttrAccount: account,
        ] as CFDictionary
        
        let status = SecItemDelete(query)
        AppLogger.debug("Se han borrado los datos. Status:\(status)")
    }
}

