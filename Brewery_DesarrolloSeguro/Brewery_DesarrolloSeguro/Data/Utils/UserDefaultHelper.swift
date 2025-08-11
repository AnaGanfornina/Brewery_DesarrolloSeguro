//
//  UserDefaultHelper.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 12/7/25.
//

import Foundation
import CryptoKit


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
       
        //encriiptamos los datos
        let encryptFavoriteID =  encryptWithExistingKey(input: favoriteData)
        // let encryptFavoriteID = encrypt(input: favoriteData, key: "pruebaClave")
        
        
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
        
        guard  let favoriteKey = KeychainHelper.keychain.readKey() else{
            AppLogger.debug("Error to read key from keychain")
            return[]
        }
        
        for item in encryptedArray {
            let decryptedData = decryptWithExistingKey(input: item, key: favoriteKey)
            // decrypt(input: item, key: "pruebaClave")
            
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
    func deleteFavorites(){
        UserDefaults.standard.removeObject(forKey: "favorites")
        KeychainHelper.keychain.deleteKey()
    }
    
    // MARK: - Encrypt
    
    // MARK: - Opcion 3
    
    
    /// Obtiene la clave existente del keychain o crea una nueva si no existe
        /// - Returns: La clave de encriptación
        private func getOrCreateKey() -> SymmetricKey {
            // Intentar leer la clave existente
            if let existingKey = KeychainHelper.keychain.readKey() {
                AppLogger.debug("Using existing key from keychain")
                return existingKey
            }
            
            // Si no existe, creamos una nueva
            AppLogger.debug("Creating new key and saving to keychain")
            let newKey = SymmetricKey(size: .bits256)
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
    
    
    
    enum AESKeySize: Int {
        case bits128 = 16
        case bits192 = 24
        case bits256 = 32
    }
    
    // MARK: - Opcion 2
    
    /// Generates a completely random cryptographically secure key for AES encryption.
    /// This provides the highest level of security but requires secure key storage and exchange.
    /// - Parameter keySize: The size of the key to generate (.bits128, .bits192, or .bits256).
    /// - Returns: A randomly generated SymmetricKey.
    func generateAndSaveRandomKey(keySize: SymmetricKeySize = .bits256) -> SymmetricKey {
        let key = SymmetricKey(size: keySize)
        KeychainHelper.keychain.saveKey(key)
        return key
    }
    
    /// Encrypts data using AES-GCM with a randomly generated key.
    /// Returns both the encrypted data and the key used for encryption.
    /// - Parameter input: The data to be encrypted.
    /// - Returns: the encrypted data
    func encryptWithRandomKey(input: Data) -> Data {
        let key = generateAndSaveRandomKey()
        
        do {
            let sealed = try AES.GCM.seal(input, using: key)
            return (sealed.combined!)
        } catch {
            return ("Error while encryption".data(using: .utf8)!)
        }
    }
    
    // Decrypts data using AES-GCM with the same random key used for encryption.
    /// - Parameters:
    ///  - input: The encrypted data to be decrypted.
    ///  - key: The same SymmetricKey that was used for encryption.
    /// - Returns: The decrypted data.
    func decryptWithRandomKey(input: Data, key: SymmetricKey) -> Data {
        do {
            let box = try AES.GCM.SealedBox(combined: input)
            let opened = try AES.GCM.open(box, using: key)
            return opened
        } catch {
            return "Error while decryption".data(using: .utf8)!
        }
    }
    
    
    
    
    
    
    // MARK: - Opcion 1
    func paddedKey_PKCS7(from key: String, withSize size: AESKeySize = .bits256) -> Data {
        // Get the data from the key in Bytes
        guard let keyData = key.data(using: .utf8) else { return Data() }
        // If the key is already the right size, return it
        if(keyData.count == size.rawValue) {return keyData}
        // If the key is bigger, truncate it and return it
        if(keyData.count > size.rawValue) {return keyData.prefix(size.rawValue)}
        // If the key is smaller, pad it
        let paddingSize = size.rawValue - keyData.count % size.rawValue
        let paddingByte: UInt8 = UInt8(paddingSize)
        let padding = Data(repeating: paddingByte, count: paddingSize) // Adding bytes (the value of the bytes are the same that the needed bytes for the padding)
        return keyData + padding
    }
    
    /// Decrypts a given data input using AES algorithm.
    /// Given the symmetric nature of the AES encryption, the key used for encryption has to be used for decryption.
    /// - Parameters:
    /// - input: The data to be decrypted.
    /// - key: The key to be used for decryption. If the key is 32 bytes long, it will be used directly. If the key is shorter than 32 bytes, it will be padded.
    private func decrypt(input: Data, key: String) -> Data {
        do {
            // Get the correct length key
            let keyData = paddedKey_PKCS7(from: key, withSize: .bits128)
            // Get the symmetric key from the key as a string
            let key = SymmetricKey(data: keyData)
            // Get box from the input, if the data is not a box then throw an error
            let box = try AES.GCM.SealedBox(combined: input)
            // Get the plaintext. If any error occurs during the opening process then throw exception
            let opened = try AES.GCM.open(box, using: key)
            // Return the cipher text
            return opened
        } catch {
            return "Error while decryption".data(using: .utf8)!
        }
    }
    
    /// Encrypts a given data input using AES algorithm.
    /// Given the symmetric nature of the AES encryption, the key used for encryption has to be used for decryption.
    /// - Parameters:
    ///  - input: The data to be encrypted.
    ///  - key: The key to be used for encryption. If the key is 32 bytes long, it will be used directly. If the key is shorter than 32 bytes, it will be padded with zeros.
    func encrypt(input: Data, key: String) -> Data {
        do {
            // Get the correct length key
            let keyData = paddedKey_PKCS7(from: key, withSize: .bits128) // 16, 24 OR 32 bytes long
            // Get the symmetric key from the key as a string
            let key = SymmetricKey(data: keyData)
            // Create the box containing the data with the key
            let sealed = try AES.GCM.seal(input, using: key)
            // Return the combination of the nonce, cypher text and tag
            return sealed.combined!
        } catch {
            return "Error while encryption".data(using: .utf8)!
        }
    }
    
    
}
