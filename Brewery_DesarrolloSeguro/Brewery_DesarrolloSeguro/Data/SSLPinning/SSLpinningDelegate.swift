//
//  SSLpinningDelegate.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 22/6/25.
//

import Foundation
import CryptoKit

final class SSLPinningDelegate: NSObject{
    private var localPublicKeyHashBase64 = ""
    
    override init(){
        let dataPK: [UInt8] =
        [0xA1-0x3C,0x73-0x20,0x5F-0x0A,0x18+0x3D,0x24+0x22,0x84-0x2B,0xB5-0x4F,0x5C+0x0B,0xA7-0x3A,0x00+0x65,0x1C+0x39,0x27+0x1B,0x9E-0x39,0x3E+0x0B,0x57-0x06,0xA5-0x51,0x15+0x3E,0x5A+0x14,0x4E-0x1C,0x64+0x04,0x5B+0x0F,0x10+0x24,0x81-0x0B,0x49+0x20,0x5E-0x0F,0x40+0x12,0x49-0x1E,0x72+0x08,0x08+0x2A,0x42+0x0A,0x3C+0x17,0x90-0x45,0x21+0x47,0x64-0x18,0x10+0x40,0x39+0x2D,0xE8-0x73,0x78-0x24,0x36+0x1C,0x01+0x56,0x2D+0x23,0xAD-0x54,0xAF-0x40,0x5B-0x1E]
        
        guard let unwrappedPublicKeyHash = String(data: Data(dataPK), encoding: .utf8) else {
            AppLogger.debug("SSLPinning error: unable to obtain local public key")
            return
        }
        self.localPublicKeyHashBase64 = unwrappedPublicKeyHash
    }
}

extension SSLPinningDelegate: URLSessionDelegate{
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        // Código de validación SSL
        // guard let si presenta el certificado else { completionHandler(.cancelAuthenticationChallenge,nil) }
        guard let serverTrust = challenge.protectionSpace.serverTrust  else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            print("SSLPinning error: server didn't present trust")
            return
        }
        
        // guard let si hay un array de certificados y en el primer hueco tenemos el certificado del servidor
        let serverCertificates: [SecCertificate]?
        serverCertificates = SecTrustCopyCertificateChain(serverTrust) as? [SecCertificate]
        // Unwrap server certificate, if not available, then SSLPinning error
        guard let serverCertificate = serverCertificates?.first else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            AppLogger.debug("SSLPinning error: server certificate is nil")
            return
        }
        // guard let si el certificado del servidor tiene la public key
        guard let serverPublicKey = SecCertificateCopyKey(serverCertificate) else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            AppLogger.debug("SSLPinning error: server public key is nil")
            return
        }
        // Transform the public key to data (currently is a SecKey)
        guard let serverPublicKeyRep = SecKeyCopyExternalRepresentation(serverPublicKey, nil) else {
            AppLogger.debug("SSLPinning error: unable to convert server public key to data")
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        let serverPublicKeyData: Data = serverPublicKeyRep as Data
    
        let serverHashKeyBase64 = sha256CryptoKit(data: serverPublicKeyData)
        //print(serverHashKeyBase64)
        //print(localPublicKeyHashBase64)

        // guard let si las public key del servidor y la que tenemos en el programa coinciden
        if serverHashKeyBase64 == self.localPublicKeyHashBase64 {
            // Success -> the server key is the expected key. Complete the process and send the credentials
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
            AppLogger.debug("SSLPinning filter passed")
        } else{
            // Error -> the server key differs from the expected key. Cancel the process
            AppLogger.debug("SSLPinning error: server certificate doesn't match")
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
        
    }
}



extension SSLPinningDelegate {
    func sha256CryptoKit(data: Data) -> String {
        let hash = SHA256.hash(data: data)
        return Data(hash).base64EncodedString()
    }
}
