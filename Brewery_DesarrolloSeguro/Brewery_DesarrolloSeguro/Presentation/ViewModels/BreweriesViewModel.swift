//
//  BreweriesViewModel.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 20/6/25.
//

import Foundation
import Combine

@Observable
final class BreweryViewModel{
    //publicadores
    var beweryData = [Brewery]()
    
    @ObservationIgnored
    private var useCase: BreweriesUseCaseProtocol
    
    
    
    init(useCase : BreweriesUseCaseProtocol  = BreweriesUseCase()){
        self.useCase = useCase
        
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
}
