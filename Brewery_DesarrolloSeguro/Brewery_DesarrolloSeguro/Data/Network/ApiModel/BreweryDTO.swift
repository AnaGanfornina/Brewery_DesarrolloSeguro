//
//  BreweryDTO.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 18/8/25.
//

import Foundation



struct BreweryDTO: Codable, Identifiable {
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
    
    
    
    enum CodingKeys: String, CodingKey {
        case id, name, city, country, longitude, latitude, phone, state, street
        case breweryType = "brewery_type"
        case address1 = "address_1"
        case address2 = "address_2"
        case address3 = "address_3"
        case stateProvince = "state_province"
        case postalCode = "postal_code"
        case websiteURL = "website_url"
    }
    
    

    
}




extension BreweryDTO {
    
    func mapToBrewery() -> Brewery {
            return Brewery(
                id: id,
                name: name,
                breweryType: breweryType,
                address1: address1,
                address2: address2,
                address3: address3,
                city: city,
                stateProvince: stateProvince,
                postalCode: postalCode,
                country: country,
                longitude: longitude,
                latitude: latitude,
                phone: phone,
                websiteURL: websiteURL,
                state: state,
                street: street
            )
        }
}
