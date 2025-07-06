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
        
        // Comprobar si los datos están en el keychain // TODO: Probar a meterlo en un do catch
        if KeychainHelper.keychain.readBreweryes() == nil{
            
            let data = await useCase.getBreweries()
            KeychainHelper.keychain.saveBreweryes(data)
            
        }
        // Leer los datos de keychain 
        if let savedBreweryes = KeychainHelper.keychain.readBreweryes() {
            self.beweryData = savedBreweryes
        }

        
        
    
        
    }
}
