//
//  EncrytHelper.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 11/8/25.
//

import Foundation
import CryptoKit

// MARK: - Encrypt

enum AESKeySize: Int {
    case bits128 = 16
    case bits192 = 24
    case bits256 = 32
}

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

