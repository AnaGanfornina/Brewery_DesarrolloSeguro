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
    
    
    // Estado local para el diálogo
    @State private var showLogoutDialog = false
    
    
    
    
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
                        
                        showLogoutDialog.toggle()
                    } label: {
                        Label("Close", systemImage: "power")
                        
                    }
                    
                }
            }
            .confirmationDialog("Aviso al usuario", isPresented: $showLogoutDialog) {
                Button("Sí, borrar", role: .destructive) {
                    appState.closeSessionUserAndEraseCredentials()
                }
                Button("Solo cerrar sesión") {
                    appState.closeSessionUser()
                    AppLogger.debug("Info: salimos de la aplicación sin borrar credenciales")
                }
                Button("Cancelar", role: .cancel) { }
            } message: {
                Text("¿Desea salir de la cuenta borrando credenciales?")
            }
        }
        
        
        
    }
}

#Preview {
    PrincipalFavoritesView(viewModel: .constant(BreweryViewModel(useCase: BreweriesUseCaseMock(),
                                                                 authentication: Authentication(context: AppState().authenticationContext))))
        .environment(AppState())
}
