//
//  BreweryRowView.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 17/8/25.
//

import SwiftUI

struct BreweryRowView: View {
    var brewery: Brewery
    init(brewery: Brewery) {
        self.brewery = brewery
    }
    
    var body: some View {
        HStack(spacing: 8){
            // Imagen que depende del tipo de cervecería
            Image(brewery.defaultImageName)
                .resizable()
                .frame(width: 50,height: 50)
               
                
            
            Text(brewery.name)
            
            Spacer()
            
        }

        
        
    }
}

#Preview {
    let model = Brewery(
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
    
    BreweryRowView(brewery: model)
}
