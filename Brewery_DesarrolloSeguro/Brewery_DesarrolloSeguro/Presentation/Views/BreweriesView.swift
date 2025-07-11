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
  
  
    var body: some View {
        // lista de cervecería
        NavigationStack {
            List {
                ForEach(viewModel.beweryData){ bewery in
                    NavigationLink {
                        // Destination
                    } label: {
                        Text(bewery.name)
                            .swipeActions(edge:.trailing, allowsFullSwipe: false) {
                                Button {
                                    // action
                                    viewModel.addFavorite(bewery)
                                    AppLogger.debug("Info: es favorito")
                                    
                                } label: {
                                    Label("Favorite", systemImage: "heart.fill")
                                }
                                .tint(.red)

                            }
                    }
                    
                }
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
        }//Navigation
    }
}

#Preview {
    BreweriesView(viewModel: .constant(BreweryViewModel(useCase: BreweriesUseCaseMock())))
        .environment(AppState())
}
