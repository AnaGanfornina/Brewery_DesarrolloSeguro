//
//  BreweriesView.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 20/6/25.
//

import SwiftUI

struct BreweriesView: View {
    @Environment(AppState.self) var appState
    
    let viewModel: BreweryViewModel
    @State var brewerySelected: Brewery?
    
    // Estado local para el diálogo
    @State private var showLogoutDialog = false
    
    
    
    var body: some View {
        // lista de cervecería
        
        NavigationStack {
            ZStack {
                /*
                Image(.fomdoCream)
                    .resizable()
                    .scaledToFill()
                    .opacity(0.3)
                 */
                
                List {
                    ForEach(viewModel.beweryData){ brewery in
                        BreweryRowView(brewery: brewery)
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
                .navigationTitle(Text("Breweries"))
                .navigationBarTitleDisplayMode(.automatic)
                
                
               // .scrollContentBackground(.hidden) // Oculta el fondo por defecto de la lista
                //.background(.clear)
                
                
                .alert(isPresented: Binding(
                                    // Hacemos un binding manual ya que el vm puede ser opcional
                                    get: { viewModel.showAlertFavorite },
                                    set: { _ in viewModel.dismissFavoriteAlert() }
                                )) {
                                    Alert(
                                        title: Text("Aviso al usuario"),
                                        message: Text("Debe logearse para poder guardar sus favoritos"),
                                        dismissButton: .default(Text("Aceptar")) {
                                            viewModel.dismissFavoriteAlert()
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
            
        }
        // Modal
        .sheet(item: $brewerySelected) { brewery in
            BrewerieDetail(viewModel: viewModel, brewerySelected: brewery)
        }
      
    }//Navigation
}

#Preview {
    let appState = AppState()
    let viewModel = BreweryViewModel(
        useCase: BreweriesUseCaseMock(),
        authentication: Authentication(context: appState.authenticationContext)
    )

    return BreweriesView(viewModel: viewModel)
        .environment(appState)
}
    
    




