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
                                
                                
                            } label: {
                                Label("Favorite", systemImage: "heart.fill")
                            }
                            .tint(.greenBrewery)
                            
                            
                        }
                }//ForEach
            }//List
            .alert(isPresented: $viewModel.showAlertFavorite) {
                Alert(
                    title: Text("Aviso al usuario"),
                    message: Text("Debe logearse para poder guardar sus favoritos"),
                    dismissButton: .default(Text("Aceptar"))
                )
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
