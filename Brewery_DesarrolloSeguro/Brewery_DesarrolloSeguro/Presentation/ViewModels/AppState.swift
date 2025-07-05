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
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // Código que se ejecuta después de 3 segundos
            print("Han pasado 3 segundos")
            self.isLogged = true
            self.status = .loaded
        }
    }
    
    func closeSessionUser(){
        Task{
            //TODO: Borrar del keychain la lista de favoritos
            self.status = .none
        }
    }
    
}

