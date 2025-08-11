//
//  BreweriesView.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 20/6/25.
//

import SwiftUI

struct BreweriesView: View {
    @Environment(AppState.self) var appState
    
    @Binding var viewModel: BreweryViewModel
    @State var brewerySelected: Brewery?
  
  
    var body: some View {
        // lista de cervecería
        NavigationStack {
            List {
                ForEach(viewModel.beweryData){ brewery in
                    Text(brewery.name)
                        .onTapGesture {
                            // Destination
                            brewerySelected = brewery
                        }
                    
                        .swipeActions(edge:.trailing, allowsFullSwipe: false) {
                            Button {
                                // action
                                viewModel.addFavorite(brewery)
                                AppLogger.debug("Info: es favorito")
                                
                            } label: {
                                Label("Favorite", systemImage: "heart.fill")
                            }
                            .tint(.red)
                            
                        }
                }//ForEach
            }//List
        }
        .refreshable {
            Task{
                await viewModel.getBreweries()
            }
        }
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    //Action here
                    appState.closeSessionUser()
                } label: {
                    Label("Close", systemImage: "power")
                }
                
            }
        }
        // Modal
        .sheet(item: $brewerySelected) { brewery in
            BrewerieDetail(viewModel: $viewModel, brewerySelected: brewery)
        }
    }//Navigation
}


#Preview {
    BreweriesView(viewModel: .constant(BreweryViewModel(useCase: BreweriesUseCaseMock())))
        .environment(AppState())
}
