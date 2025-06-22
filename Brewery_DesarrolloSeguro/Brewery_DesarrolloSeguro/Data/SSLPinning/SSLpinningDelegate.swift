//
//  SSLpinningDelegate.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 22/6/25.
//

import Foundation
import CryptoKit

final class SSLPinningDelegate: NSObject{
    private var localPublicKeyHashBase64 = "u4lDv3Ytpm/BHr9z271H4I29orWATvWy/CCZq3Aqj3E="
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
            print("SSLPinning error: server certificate is nil")
            return
        }
        // guard let si el certificado del servidor tiene la public key
        guard let serverPublicKey = SecCertificateCopyKey(serverCertificate) else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            print("SSLPinning error: server public key is nil")
            return
        }
        // Transform the public key to data (currently is a SecKey)
        guard let serverPublicKeyRep = SecKeyCopyExternalRepresentation(serverPublicKey, nil) else {
            print("SSLPinning error: unable to convert server public key to data")
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
            print("SSLPinning filter passed")
        } else{
            // Error -> the server key differs from the expected key. Cancel the process
            print("SSLPinning error: server certificate doesn't match")
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
