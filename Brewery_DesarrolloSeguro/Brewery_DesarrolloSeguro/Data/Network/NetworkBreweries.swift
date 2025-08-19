//
//  NetworkBreweries.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 20/6/25.
//

import Foundation

protocol NetworkBreweriesProtocol {
    func getBreweries() async ->[BreweryDTO]
}

final class NetworkBreweries: NetworkBreweriesProtocol{
    
    func getBreweries() async -> [BreweryDTO] {
        var modelReturn = [BreweryDTO]()
        
        guard let urlCad = String(data: Data(ConstantsApp.CONST_API_URL), encoding: .utf8) else {
            print("NetworkBreweries Error: unwrappederror CONST_API_URL")
            return []
        }
        
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
            if let resp = response as? HTTPURLResponse {
                if resp.statusCode == HttpResponseCodes.SUCCESS {
                    modelReturn = try! JSONDecoder().decode([BreweryDTO].self, from: data)
                }
            }
        } catch {
            //TODO: Tratar error
            NSLog("Error calling NetworkBreweries")
        }
        return modelReturn
    }
}
// MARK: - NetworkBreweries Mock

final class NetworkBreweriesMock: NetworkBreweriesProtocol{
    func getBreweries() async -> [BreweryDTO] {
        let model1 = BreweryDTO(
            id: "701239cb-5319-4d2e-92c1-129ab0b3b440",
            name: "Bière de la Plaine Mock",
            breweryType: "micro",
            address1: "16 Rue Saint Pierre",
            address2: nil,
            address3: nil,
            city: "Marseille",
            stateProvince: "Bouche du Rhône",
            postalCode: "13006",
            country: "France",
            longitude: 5.38767154,
            latitude: 43.29366192,
            phone: "491473254",
            websiteURL: "https://brasseriedelaplaine.fr/",
            state: "Bouche du Rhône",
            street: "16 Rue Saint Pierre")
        
        let model2 = BreweryDTO(
            id: "ac41870a-13d1-446c-80e4-6cb4570f5fbb",
            name: "La Minotte Mock",
            breweryType: "micro",
            address1: "14 Blvd de l'Europe",
            address2: nil,
            address3: nil,
            city:"Vitrolles",
            stateProvince: "Bouche du Rhône",
            postalCode: "13127",
            country: "France",
            longitude: 5.24158474,
            latitude: 43.43965026,
            phone: "465948644",
            websiteURL: "https://www.minot-brasserie.fr/",
            state: "Bouche du Rhône",
            street: "14 Blvd de l'Europe")
        
        return [model1, model2]
    }   
}
