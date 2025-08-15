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
    
    // Estado local para el diálogo
    @State private var showLogoutDialog = false
    
    
    
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
                                
                                
                            } label: {
                                Label("Favorite", systemImage: "heart.fill")
                            }
                            .tint(.greenBrewery)
                            
                            
                        }
                }//ForEach
            }//List
            .alert(isPresented: $viewModel.showAlertFavorite){
                Alert(
                    title: Text("Aviso al usuario"),
                    message: Text("Debe logearse para poder guardar sus favoritos"),
                    dismissButton: .default(Text("Aceptar")) {
                        viewModel.showAlertFavorite = false
                        
                    }
                )
            }
            .confirmationDialog("Aviso al usuario", isPresented:  $showLogoutDialog) {
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
            
            .refreshable {
                Task{
                    await viewModel.getBreweries()
                }
            }
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        //Action here
                        showLogoutDialog.toggle()
                    } label: {
                        Label("Close", systemImage: "power")
                    }
                    
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
    let appState = AppState()
        return BreweriesView(
            viewModel: .constant(BreweryViewModel(
                useCase: BreweriesUseCaseMock(),
                authentication: Authentication(context: appState.authenticationContext)
            ))
        )
        .environment(appState)
}
