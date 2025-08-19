//
//  PrincipalView.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 26/6/25.
//

import SwiftUI
import LocalAuthentication

struct PrincipalView: View {
    
    
    @Environment(AppState.self) private var appState
    @State var viewModel: BreweryViewModel?
    
    init(viewModel: BreweryViewModel = BreweryViewModel(authentication: Authentication(context: LAContext()))) {
           self.viewModel = viewModel
       }
    
    var body: some View {
        Group{
            if let viewModel = viewModel{
                TabView{
                    BreweriesView(viewModel: viewModel)
                        .background(Color.cream)
                        .tabItem {
                            Image(systemName: "house")
                            Text("Home")
                        }
                    
                    PrincipalFavoritesView(viewModel: viewModel)
                        .tabItem {
                            Image(systemName: "heart.fill")
                            Text("Favorites")
                        }
                }
                .tint(.greenBrewery) // aplica el color a los iconos
                
            } else {
                ProgressView("Inicializando sesión...")
                    .onAppear {
                        initializeViewModel()
                    }
            }
        }
        .onChange(of: appState.isLogged) { oldValue, newValue in
                   handleSessionChange(wasLogged: oldValue, isNowLogged: newValue)
               }
    }
    
    // MARK: - Private Methods
    
    private func initializeViewModel() {
        guard appState.isLogged else { return }
        
        // Crear nuevo ViewModel con contexto compartido del AppState
        let authentication = Authentication(context: appState.authenticationContext)
        let newViewModel = BreweryViewModel(authentication: authentication)
        
        // Inicializar para nueva sesión
        newViewModel.initializeForNewSession()
        
        // Asignar
        viewModel = newViewModel
        
        AppLogger.debug("ViewModel inicializado correctamente")
    }
    
    private func handleSessionChange(wasLogged: Bool, isNowLogged: Bool) {
        if isNowLogged && !wasLogged {
            // Usuario acaba de hacer login
            AppLogger.debug("Detectado login - inicializando ViewModel")
            initializeViewModel()
            
        } else if !isNowLogged && wasLogged {
            // Usuario acaba de hacer logout
            AppLogger.debug("Detectado logout - limpiando ViewModel")
            
            // Limpiar ViewModel actual
            viewModel?.cleanupForSessionEnd()
            viewModel = nil
        }
    }
}

#Preview {
    PrincipalView()
        .environment(AppState())
}
