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
    let viewModel: BreweryViewModel
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
                    BreweryRowView(brewery: favorite)
                    //.background(Color.cream) // Fondo color crema
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.greenBrewery, lineWidth: 1)
                        )
                    //.baackground(Color.greenBrewery.opacity(0.1))
                        .listRowBackground(Color.clear) // Elimina el fondo por defecto de la celda
                        .listRowInsets(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 0.5))
                        .listRowSeparator(.hidden) // Oculta los separadores por defecto
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
                BrewerieDetail(viewModel: viewModel, brewerySelected: brewery)
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
    
    FavoritesView(viewModel: BreweryViewModel(useCase: BreweriesUseCaseMock(),
                                                        authentication: Authentication(context: AppState().authenticationContext)))
        .environment(AppState())
    
    
}
