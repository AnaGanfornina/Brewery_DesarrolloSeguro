//
//  AppState.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 26/6/25.
//

import Foundation

@Observable
final class AppState {
    var status = Status.none
    var isLogged: Bool = false
   
    // MARK: - Functions
    
    func loginApp(){
        self.status = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Código que se ejecuta después de 3 segundos
            AppLogger.debug("Info: Han pasado 2 segundos")
            self.isLogged = true
            self.status = .loaded
        }
    }
    
    func closeSessionUserAndEraseCredentials(){
        
        KeychainHelper.keychain.deleteBrewery()
        EncryptionManager.shared.deleteAllFavorites()
        KeychainHelper.keychain.deleteKey()
        self.status = .none
    
    }
    func closeSessionUser(){
        
        self.status = .none
            
        
    }
    
}

