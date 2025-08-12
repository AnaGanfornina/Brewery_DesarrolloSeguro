//
//  PrincipalView.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 26/6/25.
//

import SwiftUI

struct PrincipalView: View {
    
    @State var viewModel: BreweryViewModel
    
    init(viewModel: BreweryViewModel = BreweryViewModel()){
        self.viewModel = viewModel
    }
    
    var body: some View {
        TabView{
            BreweriesView(viewModel: $viewModel)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
          
            
            
            PrincipalFavoritesView(viewModel: $viewModel)
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                    
                    /*
                     FavoritesView(viewModel: $viewModel)
                     .tabItem {
                     Image(systemName: "heart.fill")
                     Text("Favorites")
                     }
                     
                     */
                    
                }
        }
        
        .tint(.greenBrewery) // aplica el color a los iconos
    }
}

#Preview {
    PrincipalView()
        .environment(AppState())
}
