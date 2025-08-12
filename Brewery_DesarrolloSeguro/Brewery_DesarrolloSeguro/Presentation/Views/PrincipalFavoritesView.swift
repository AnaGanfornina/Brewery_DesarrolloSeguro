//
//  PrincipalFavoritesView.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 12/8/25.
//

import SwiftUI

struct PrincipalFavoritesView: View {
    
    @Environment(AppState.self) var appState
    @Binding var viewModel: BreweryViewModel
    
    var body: some View {
        NavigationStack{
            Group{
                
                if viewModel.keyState == nil {
                    GetStarted(viewModel: $viewModel)
                } else {
                    FavoritesView(viewModel: $viewModel)
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
        }
        
        
        
    }
}

#Preview {
    PrincipalFavoritesView(viewModel: .constant(BreweryViewModel(useCase: BreweriesUseCaseMock())))
        .environment(AppState())
}
