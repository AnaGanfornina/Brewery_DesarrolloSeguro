//
//  SSLPinningSecureURLSession.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 22/6/25.
//

import Foundation

final class SSLPinningSecureURLSession {
    // MARK: - Variables
    
    let session: URLSession
    
    // MARK: - Initializers
    
    init(){
        session = URLSession(
            configuration: .ephemeral,
            delegate: SSLPinningDelegate(),
            delegateQueue: nil)
    }
   
}

extension URLSession {
    static var shared: URLSession {
        return SSLPinningSecureURLSession().session
    }
}
