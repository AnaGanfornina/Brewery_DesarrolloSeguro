//
//  BreweriesView.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 20/6/25.
//

import SwiftUI

struct BreweriesView: View {
    @Environment(AppState.self) var appState
    @State var viewModel: BreweryViewModel
    
    
    init(viewModel: BreweryViewModel = BreweryViewModel()){
        self.viewModel = viewModel
    }
    
    
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
                                    // TODO:  Marcar como favorito
                                    print("Es favorito")
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
    BreweriesView(viewModel: BreweryViewModel(useCase: BreweriesUseCaseMock()))
        .environment(AppState())
}
