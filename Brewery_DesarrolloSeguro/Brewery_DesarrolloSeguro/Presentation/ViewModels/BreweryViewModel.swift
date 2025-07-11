//
//  BreweryViewModel.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 11/7/25.
//

import Foundation
import Combine

@Observable
final class BreweryViewModel{
    //publicadores
    var beweryData = [Brewery]()
    var favoritesBeweryes : [Brewery] = []
    
    @ObservationIgnored
    private var useCase: BreweriesUseCaseProtocol
    
    
    
    init(useCase : BreweriesUseCaseProtocol  = BreweriesUseCase()){
        self.useCase = useCase
        
        Task{
            await self.getBreweries()
        }
        self.getFavoriteBreweries()
        
        
    }
    
    @MainActor
    func getBreweries() async {
        Task{
            self.beweryData =  await useCase.getBreweries()
            
        }
    }
    
    func addFavorite(_ brewery: Brewery){
        useCase.addFavorites(brewery)
        getFavoriteBreweries()
        
    }
    
    func getFavoriteBreweries() {
        self.favoritesBeweryes = useCase.getFavoriteBreweries()
    }
}
