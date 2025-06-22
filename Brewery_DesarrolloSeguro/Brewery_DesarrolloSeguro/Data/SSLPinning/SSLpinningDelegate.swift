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
        [0x67+0x0E,0x3F-0x0B,0xA3-0x37,0x42+0x02,0x4A+0x2C,0x17+0x1C,0x96-0x3D,0xCA-0x56,0xDA-0x6A,0x29+0x44,0x36-0x07,0x35+0x0D,0x52-0x0A,0xDA-0x68,0x1B+0x1E,0x63+0x17,0x03+0x2F,0x33+0x04,0x44-0x13,0x83-0x3B,0x4F-0x1B,0x78-0x2F,0x3B-0x09,0x66-0x2D,0x22+0x4D,0x15+0x5D,0x76-0x1F,0x04+0x3D,0x3C+0x18,0xDB-0x65,0x32+0x25,0xE9-0x70,0x1D+0x12,0x6F-0x2C,0x2D+0x16,0x3B+0x1F,0xB4-0x43,0x5B-0x28,0x59-0x18,0xC2-0x51,0xC7-0x5D,0x57-0x24,0x18+0x2D,0x19+0x24]
        
        guard let unwrappedPublicKeyHash = String(data: Data(dataPK), encoding: .utf8) else {
            print("SSLPinning error: unable to obtain local public key")
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
