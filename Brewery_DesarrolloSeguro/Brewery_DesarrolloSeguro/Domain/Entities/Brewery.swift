//
//  Brewery.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 20/6/25.
//


import Foundation

struct Brewery: Codable, Identifiable {
    let id: String
    let name: String
    let breweryType: String
    let address1: String?
    let address2: String?
    let address3: String?
    let city: String
    let stateProvince: String
    let postalCode: String
    let country: String
    let longitude: Double?
    let latitude: Double?
    let phone: String?
    let websiteURL: String?
    let state: String
    let street: String?
    
    
    // propiedad computada para obtener la imagen según el tipo
    var defaultImageName: String {
        switch breweryType.lowercased() {
        case "contract": return "contract_brewery"
        case "large": return "LargeBrewery"
        case "micro": return "MicroBrewery"
        case "propietor": return "PropietorBrewery"
        case "brewpub": return "Brewpub"
        case "closed": return "closedBrewery"
        default: return "brewpub_brewery" // imagen por defecto
        }
       
    }
    
}
