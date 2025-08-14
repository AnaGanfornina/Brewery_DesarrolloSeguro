//
//  UserDefaultHelper.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 12/7/25.
//

import Foundation
import CryptoKit

/*
final class UserDefaultsHelper {
    
    // MARK: - Properties
    static let defaults = UserDefaultsHelper()

    
    // MARK: - Functions
    private init() {}
    
    func save(_ favoriteID : String) {
        var favorites = UserDefaults.standard.array(forKey: "favorites") as? [Data] ?? []
        
        
        //pasamos el string a data
        
        guard let favoriteData = favoriteID.data(using: .utf8) else {
            AppLogger.debug("Error to convert string to data")
            return
        }
       
        //encriptamos los datos
       // let encryptFavoriteID =  encryptWithExistingKey(input: favoriteData, authentication: authentication)
        let encryptFavoriteID =  encryptWithExistingKey(input: favoriteData)
    
        
        
        favorites.append(encryptFavoriteID)
        UserDefaults.standard.set(favorites, forKey: "favorites")
    }
    func readFavorites() -> [String]? {
        
        //  Leer el array de Data encriptado
        guard let encryptedArray = UserDefaults.standard.array(forKey: "favorites") as? [Data] else {
            AppLogger.debug("No favorites found")
            return []
        }
        // desencriptarlos
        
        var favorites: [String] = []
        // leemos la clave del keychain
        
        //guard  let favoriteKey = KeychainHelper.keychain.readKeyWithAutentication(authentication: <#T##Authentication#>) else{
        guard  let favoriteKey = KeychainHelper.keychain.readKey() else{
            AppLogger.debug("Error to read key from keychain")
            return[]
        }
        
        for item in encryptedArray {
            let decryptedData = decryptWithExistingKey(input: item, key: favoriteKey)

            
            // convertir cada uno a string
            
            if let favoriteID = String(data: decryptedData, encoding: .utf8) {
                favorites.append(favoriteID)
            } else {
                AppLogger.debug("Error decoding favorite")
            }
        }
        // retornarlos
        return favorites
    }
    
    func deleteFavorite(_ favorite: String) {
        // leemos los datos de userDefault
        guard let encryptedArray = UserDefaults.standard.array(forKey: "favorites") as? [Data] else {
                    return
                }
        // leemos la clave de keychain
        guard let key = KeychainHelper.keychain.readKey() else {
                   AppLogger.debug("Error to read key from keychain")
                   return
               }
        
        // Filtrar los favoritos desencriptando cada uno para comparar
                let filteredFavorites = encryptedArray.filter { encryptedData in
                    
                    let decryptedData = decryptWithExistingKey(input: encryptedData, key: key)
                    
                    if let favoriteID = String(data: decryptedData, encoding: .utf8) {
                        return favoriteID != favorite
                    }
                    
                    return true // si no se puede leer el elemento, lo deja en la lista
                }
                
                UserDefaults.standard.set(filteredFavorites, forKey: "favorites")
        
    }
    func deleteAllFavorites(){
        UserDefaults.standard.removeObject(forKey: "favorites")
        KeychainHelper.keychain.deleteKey()
    }
    
    func generateNewKey(authentication: Authentication){
        KeychainHelper.keychain.deleteKey()
        let newKey = SymmetricKey(size: .bits256)
        //KeychainHelper.keychain.saveKeyWithAuthentication(data: newKey, autentication: authentication)
        KeychainHelper.keychain.saveKey(newKey)
    }
    
    // MARK: - Encrypt
    
    /*
    /// Obtiene la clave existente del keychain o crea una nueva si no existe
        /// - Returns: La clave de encriptación
        private func getOrCreateKey() -> SymmetricKey {
            // Intentar leer la clave existente
            //if let existingKey = KeychainHelper.keychain.readKeyWithAutentication(authentication: authentication) {
            if let existingKey = KeychainHelper.keychain.readKey() {
                AppLogger.debug("Using existing key from keychain")
                return existingKey
            }
            
            // Si no existe, creamos una nueva
            AppLogger.debug("Creating new key and saving to keychain")
            let newKey = SymmetricKey(size: .bits256)
            //KeychainHelper.keychain.saveKeyWithAuthentication(data: newKey, autentication: authentication)
            KeychainHelper.keychain.saveKey(newKey)
            return newKey
        }
    
    
    // Encripta datos usando una clave específica (no genera nueva)
        /// - Parameters:
        ///   - input: Los datos a encriptar
        ///   - key: La clave a usar para encriptar
        /// - Returns: Los datos encriptados
        private func encryptWithExistingKey(input: Data) -> Data {
            do {
                // vemos si tenemos clave
                let key = getOrCreateKey()
                
                let sealed = try AES.GCM.seal(input, using: key)
                return sealed.combined!
            } catch {
                AppLogger.debug("Error while encryption: \(error)")
                return "Error while encryption".data(using: .utf8)!
            }
        }
    
    /// Desencripta datos usando una clave específica
       /// - Parameters:
       ///   - input: Los datos encriptados
       ///   - key: La clave para desencriptar
       /// - Returns: Los datos desencriptados
       private func decryptWithExistingKey(input: Data, key: SymmetricKey) -> Data {
           do {
               let box = try AES.GCM.SealedBox(combined: input)
               let opened = try AES.GCM.open(box, using: key)
               return opened
           } catch {
               AppLogger.debug("Error while decryption: \(error)")
               return "Error while decryption".data(using: .utf8)!
           }
       }
    */
    
    
}
*/
