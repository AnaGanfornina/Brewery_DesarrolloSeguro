//
//  KeyChainHelper.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 5/7/25.
//

import Foundation
import CryptoKit


// MARK: - Protocolo para KeychainHelper

/// Protocolo con todo lo referente a al autenticación
protocol KeychainHelperProtocol {
    func saveKeyWithAuthentication(data: SymmetricKey, service: String, account: String, autentication: AuthenticationProtocol)
    func readKeyWithAutentication(service: String, account: String, authentication: AuthenticationProtocol) -> SymmetricKey?
    func deleteKey()
    
    
    

}

final class KeychainHelper: KeychainHelperProtocol {
    
    static let keychain = KeychainHelper()

    
    private init() {}
    
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
            AppLogger.debug("Info: Breweries from Keychain is empty")
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
            AppLogger.debug("Error: error adding item")
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
    func saveKeyWithAuthentication(data: SymmetricKey, service: String = "AGBrewery", account: String = "Key", autentication: AuthenticationProtocol) {
        // obtenemos el control de acceso al dato
        guard let accessControl = autentication.getAccessControl() else {
            AppLogger.debug("Error: could not create access control")
            return
        }
        
        // Convertir SymetricKey a data
        // FIXME: Esto es lo que no entiendo, por que no podría usar directamente kSecClassKey si es una clave simetrica ??
        let keyData: Data = data.withUnsafeBytes { bytes in
                return Data(bytes)
            }
        
        
    
        // Crear la query
        let query = [
            kSecValueData: keyData,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecAttrAccessControl: accessControl
        ] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        

        // errSecDuplicateltem -> actualizar
        if status == errSecDuplicateItem {
            // Crear la query para actualizar el item
            let queryToUpdate = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: service,
                kSecAttrAccount: account,
                kSecAttrAccessControl: accessControl
            ] as CFDictionary
            
            let attributesToUpdate = [kSecValueData: keyData] as CFDictionary
            
            SecItemUpdate(queryToUpdate, attributesToUpdate)
        } else if status != errSecSuccess { // errSecSuccess
            AppLogger.debug("Error: error adding item")
        }
    }
        
    // Read data
    func readKeyWithAutentication(service: String = "AGBrewery", account: String = "Key", authentication: AuthenticationProtocol) -> SymmetricKey? {
        
        // le indicamos el contexto, que viene desde autentication
        let context = authentication.context
        
        // Crear la query
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecReturnData: true,
            kSecUseAuthenticationContext: context // -> esto es importante. Va a comprobar que en el contexto el usuario esté autenticado
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result) // TODO: Tratar posibles errores de autentificación con faceID
        
        guard let dataResult = result as? Data else {
            AppLogger.debug("Error: error converted SymmetricKey")
            return nil
        }
        
        return SymmetricKey(data: dataResult)
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

// MARK: - KeychainHelper Mock

final class KeychainHelperMock: KeychainHelperProtocol {
    
    // Simulamos storage en memoria para tests
    private var mockStorage: [String: SymmetricKey] = [:]
    
    
    // Para verificar llamadas en tests
    var saveKeyCallCount = 0
    var readKeyCallCount = 0
    var deleteKeyCallCount = 0
    
    func saveKeyWithAuthentication(data: SymmetricKey, service: String, account: String, autentication: any AuthenticationProtocol) {
        saveKeyCallCount += 1
        
        // Simulamos guardado sin Keychain real
        let key = "\(service)_\(account)"
        mockStorage[key] = data
        AppLogger.debug("KeyChainMock: Key saved to memory storage")
    }
    
    func readKeyWithAutentication(service: String, account: String, authentication: any AuthenticationProtocol) -> SymmetricKey? {
        readKeyCallCount += 1
        
        // Leemos desde "memoria", sin Keychain real
        let key = "\(service)_\(account)"
        let result = mockStorage[key]
        AppLogger.debug("KeyChainMock: Key read from memory storage")
        return result
    }
    
    func deleteKey() {
        deleteKeyCallCount += 1
        
        // Limpiamos el "almacenamiento "
        mockStorage.removeAll()
        AppLogger.debug("KeyChainMock: All keys deleted from memory storage")
    }
    
    
 
    
}
