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
                
                if viewModel.keyAuthentication == nil {
                    GetStarted(viewModel: $viewModel)
                } else {
                    FavoritesView(viewModel: $viewModel)
                }
            }
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        //Action here
                        
                        // Preguntar si queremos salir o salir y borrar la cuenta
                        
                        viewModel.showAlertLogout.toggle()
                    } label: {
                        Label("Close", systemImage: "power")
                        
                    }
                    
                }
            }
            .alert(isPresented: $viewModel.showAlertLogout) {
                Alert(
                    title: Text("Aviso al usuario"),
                    message: Text("¿Desea salir de la cuenta borrando credenciales?"),
                    primaryButton: .destructive(Text("Sí, borrar")) {
                        // Acción si acepta borrar
                        appState.closeSessionUserAndEraseCredentials()
                    },
                    secondaryButton: .cancel(Text("Solo cerrar sesión")) {
                        // Acción si NO quiere borrar credenciales
                        appState.closeSessionUser()
                        AppLogger.debug("Info:  salimos de la aplicación sin borrar credenciales")
                        
                    }
                    
                )
            }
        }
        
        
        
    }
}

#Preview {
    PrincipalFavoritesView(viewModel: .constant(BreweryViewModel(useCase: BreweriesUseCaseMock(),
                                                                 authentication: Authentication(context: AppState().authenticationContext))))
        .environment(AppState())
}
