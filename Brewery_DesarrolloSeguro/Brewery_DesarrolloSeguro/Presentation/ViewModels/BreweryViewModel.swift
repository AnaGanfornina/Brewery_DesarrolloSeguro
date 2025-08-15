//
//  BreweryViewModel.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 11/7/25.
//

import Foundation
import Combine
import LocalAuthentication
import CryptoKit

@Observable
final class BreweryViewModel{
    //publicadores
    var beweryData = [Brewery]()
    var favoritesBeweryes : [Brewery] = []
    var keyAuthentication : SymmetricKey?
    let authentication: Authentication
    var showAlertFavorite = false
    //var showAlertLogout = false
    
    
    
    @ObservationIgnored
    private var useCase: BreweriesUseCaseProtocol
    
    
    
    init(useCase : BreweriesUseCaseProtocol  = BreweriesUseCase(), authentication: Authentication){
        self.useCase = useCase
        self.authentication = authentication
        EncryptionManager.shared.configure(context: authentication)
        //self.keyAuthentication = KeychainHelper.keychain.readKeyWithAutentication(authentication: authentication)
        
        //self.loadKeyWithAuthentication()
        /*
        // Solo cargamos la key si ya existe, sin pedir Face ID al entrar
            if let existingKey = KeychainHelper.keychain.readKeyWithAutentication(authentication: authentication) {
                self.keyAuthentication = existingKey
            }
      
        
        
        Task{
            await self.getBreweries()
        }
         */
    }
    
    // MARK: - Session Management
        
        /// Inicializa el ViewModel para una nueva sesión
        func initializeForNewSession() {
            // Limpiar datos anteriores
            beweryData = []
            favoritesBeweryes = []
            keyAuthentication = nil
            showAlertFavorite = false
            //showAlertLogout = false
            
            // Cargar datos para la nueva sesión
            Task {
                await getBreweries()
            }
            
            // Intentar cargar key existente sin pedir Face ID
            loadExistingKeyIfAvailable()
            
            // Cargar favoritos si hay key disponible
            if keyAuthentication != nil {
                loadFavoritesFromStorage()
            }
            
            AppLogger.debug("ViewModel inicializado para nueva sesión")
        }
    
    /// Limpia el ViewModel al cerrar sesión
       func cleanupForSessionEnd() {
           beweryData = []
           favoritesBeweryes = []
           keyAuthentication = nil
           showAlertFavorite = false
           //showAlertLogout = false
           
           AppLogger.debug("ViewModel limpiado para fin de sesión")
       }
    
    /// Carga favoritos desde el almacenamiento
       func loadFavoritesFromStorage() {
           guard keyAuthentication != nil else {
               AppLogger.debug("No hay key disponible, no se pueden cargar favoritos")
               return
           }
           
           // Cargar favoritos
           getFavoriteBreweries()
           AppLogger.debug("Favoritos cargados desde storage: \(favoritesBeweryes.count)")
       }
    
    // MARK: - Public Methods
    
    @MainActor
    func getBreweries() async {
        Task{
            self.beweryData =  await useCase.getBreweries()
            
        }
    }
    
    func addFavorite(_ brewery: Brewery){
        
        if let key = keyAuthentication {
                useCase.addFavorite(brewery)
                getFavoriteBreweries()
                AppLogger.debug("Info: es favorito")
            } else {
                // Pedimos autenticación solo ahora
                authentication.authenticateUser { [weak self] success in
                    guard let self = self else { return }
                    if success {
                        self.keyAuthentication = KeychainHelper.keychain.readKeyWithAutentication(authentication: self.authentication)
                        
                        if let key = self.keyAuthentication {
                            self.useCase.addFavorite(brewery)
                            self.getFavoriteBreweries()
                        }
                    } else {
                        self.showAlertFavorite = true
                    }
                }
            }
    }
    
    func deleteFavorite(_ brewery: Brewery){
        useCase.deleteFavorite(brewery)
        getFavoriteBreweries()
        
    }
    
    func getFavoriteBreweries() {
        self.favoritesBeweryes = useCase.getFavoriteBreweries()
    }
    
    // MARK: - Private Methods
    
    
    /// Carga key existente sin pedir autenticación (solo si ya existe)
    private func loadExistingKeyIfAvailable() {
        // Solo cargamos la key si ya existe, sin pedir Face ID al entrar
        if let existingKey = KeychainHelper.keychain.readKeyWithAutentication(authentication: authentication) {
            self.keyAuthentication = existingKey
            AppLogger.debug("Key existente cargada sin autenticación")
        } else {
            AppLogger.debug("No hay key existente disponible")
        }
    }
    
    
    /// Método para autenticar al usuario y cargar la key desde Keychain
    private func loadKeyWithAuthentication() {
        
        authentication.authenticateUser { [weak self] success in
            guard let self = self else { return }
            if success {
                // Solo si se autentica correctamente leemos la key
                self.keyAuthentication = KeychainHelper.keychain.readKeyWithAutentication(authentication: self.authentication)
            } else {
                // Si falla autenticación, marcamos alerta
                self.showAlertFavorite = true
            }
        }
    }
    
    
    /// Fuerza la autenticación para cargar favoritos
    func forceAuthenticationAndLoadFavorites() {
        if keyAuthentication == nil {
            loadKeyWithAuthentication()
        } else {
            loadFavoritesFromStorage()
        }
    }
    
    
}
