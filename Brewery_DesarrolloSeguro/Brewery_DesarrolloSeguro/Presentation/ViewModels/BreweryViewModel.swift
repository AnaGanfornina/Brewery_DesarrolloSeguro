//
//  BreweryViewModel.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 11/7/25.
//

import Foundation
import Combine
import LocalAuthentication
import CryptoKit

@Observable
final class BreweryViewModel{
    //publicadores
    var beweryData = [Brewery]()
    var favoritesBeweryes : [Brewery] = []
    var keyAuthentication : SymmetricKey?
    let authentication: Authentication
    var showAlertFavorite = false
    var showAlertLogout = false

    
    
    @ObservationIgnored
    private var useCase: BreweriesUseCaseProtocol
    
    
    
    init(useCase : BreweriesUseCaseProtocol  = BreweriesUseCase()){
        self.useCase = useCase
        self.authentication = Authentication(context: LAContext())
       // self.keyAuthentication = KeychainHelper.keychain.readKeyWithAutentication(authentication: authentication)
        self.keyAuthentication = KeychainHelper.keychain.readKey()
        
        
        Task{
            await self.getBreweries()
        }
       
        
        
    }
    
    @MainActor
    func getBreweries() async {
        Task{
            self.beweryData =  await useCase.getBreweries()
            
        }
    }
    
    func addFavorite(_ brewery: Brewery){
        if keyAuthentication != nil {
            useCase.addFavorite(brewery)
            getFavoriteBreweries()
            AppLogger.debug("Info: es favorito")
        } else {
            // marcamos para que se muestre la alerta en la vista
            showAlertFavorite.toggle()
        }
        
        
    }
    
    func deleteFavorite(_ brewery: Brewery){
        useCase.deleteFavorite(brewery)
        getFavoriteBreweries()
        
    }
    
    func getFavoriteBreweries() {
        self.favoritesBeweryes = useCase.getFavoriteBreweries()
    }
}
