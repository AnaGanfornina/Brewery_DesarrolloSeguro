//
//  NetworkBreweries.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 20/6/25.
//

import Foundation

protocol NetworkBreweriesProtocol {
    func getBreweries() async ->[Brewery]
}

final class NetworkBreweries: NetworkBreweriesProtocol{
    
    func getBreweries() async -> [Brewery] {
        var modelReturn = [Brewery]()
        
        let urlCad = "\(ConstantsApp.CONST_API_URL)"
        guard let url = URL(string: urlCad) else {
            NSLog("Error: URL mal formada") // TODO: Tratar error
            return []
        }
        var request =  URLRequest(url: url)
        request.httpMethod = HttpMethods.get
        request.addValue(HttpMethods.content, forHTTPHeaderField: "Content-type")
        
        // Call to server
        do {
            let (data, response) = try await URLSession.shared.data(for: request) //TODO: Cambiar por el share nuestro
        } catch {
            //TODO: Tratar error
            NSLog("Error calling NetworkBreweries")
        }
        return modelReturn
    }
    
    
}
