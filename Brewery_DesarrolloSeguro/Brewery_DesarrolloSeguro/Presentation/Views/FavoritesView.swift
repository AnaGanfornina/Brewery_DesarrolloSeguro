//
//  FavoritesView.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 26/6/25.
//

import SwiftUI

struct FavoritesView: View {
    @Environment(AppState.self) var appState
    @State var brewerySelected: Brewery?
    @Binding var viewModel: BreweryViewModel
    var body: some View {
        
        if viewModel.favoritesBeweryes.isEmpty {
            VStack{
                Text("Listo!, añade tus favoritos en la ventana de home!")
                    .multilineTextAlignment(.center)
                    .font(.title3)
            }
        } else {
               
            List{
                ForEach(viewModel.favoritesBeweryes){ favorite in
                    Text(favorite.name)
                        .onTapGesture {
                            // Destination
                            brewerySelected = favorite
                        }
                        .swipeActions(allowsFullSwipe: true) {
                            Button {
                                viewModel.deleteFavorite(favorite)
                            } label: {
                                Image(systemName: "trash")
                            }
                            .tint(.red)
                        }
                }// ForEach
            }// List
            
            // Modal
            .sheet(item: $brewerySelected) { brewery in
                BrewerieDetail(viewModel: $viewModel, brewerySelected: brewery)
            }
            .onAppear {
                viewModel.getFavoriteBreweries()
            }
            .refreshable {
                viewModel.getFavoriteBreweries()
            }
        }
    }
}

#Preview {
    
    FavoritesView(viewModel: .constant(BreweryViewModel(useCase: BreweriesUseCaseMock(),
                                                        authentication: Authentication(context: AppState().authenticationContext))))
        .environment(AppState())
    
    
}
