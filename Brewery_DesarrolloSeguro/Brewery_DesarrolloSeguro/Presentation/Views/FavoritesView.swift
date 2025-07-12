//
//  FavoritesView.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 26/6/25.
//

import SwiftUI

struct FavoritesView: View {
    @Environment(AppState.self) var appState
   
    @Binding var viewModel: BreweryViewModel
    var body: some View {
        
        
        List{
            ForEach(viewModel.favoritesBeweryes, id: \.self){ favorite in
                Text(favorite)
            }
        }
        .onAppear {
            viewModel.getFavoriteBreweries()
        }
        .refreshable {
            viewModel.getFavoriteBreweries()
        }
    }
}

#Preview {
    
    FavoritesView(viewModel: .constant(BreweryViewModel(useCase: BreweriesUseCaseMock())))
        .environment(AppState())
    
    
}
