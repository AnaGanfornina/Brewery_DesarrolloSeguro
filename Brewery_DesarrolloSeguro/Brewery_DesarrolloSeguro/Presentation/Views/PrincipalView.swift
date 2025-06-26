//
//  PrincipalView.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 26/6/25.
//

import SwiftUI

struct PrincipalView: View {
    var body: some View {
        TabView{
            BreweriesView(viewModel: BreweryViewModel()) // TODO: Quitar la inyección
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            FavoritesView()
            .tabItem {
                Image(systemName: "heart.fill")
                Text("Favorites")
            }
        }
    }
}

#Preview {
    PrincipalView()
        .environment(AppState())
}
