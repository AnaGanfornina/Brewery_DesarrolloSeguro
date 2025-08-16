//
//  Authentication.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 13/8/25.
//

import Foundation
import LocalAuthentication


protocol AuthenticationProtocol {
    
    var context: LAContext { get }
    func authenticateUser(completion: @escaping (Bool) -> Void)
    func getAccessControl() -> SecAccessControl?
}



final class Authentication: AuthenticationProtocol {
    
    let context: LAContext
    private var error: NSError?
    
    init(context: LAContext) {
        self.context = context // Se guarda el contexto de autentificación introducido por parámetro
    }
    
    // Método que autentica al usuario y ejecuta la closure cuando termina
      func authenticateUser(completion: @escaping (Bool) -> Void) {
          if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
              let reason = "Identifícate para acceder a tus favoritos"
              context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, _ in
                  DispatchQueue.main.async {
                      completion(success)
                  }
              }
          } else {
              completion(false)
          }
      }
    
    
    func getAccessControl() -> SecAccessControl? {
        var accessControlError: Unmanaged<CFError>?
        
        // Permitimos el acceso al dato para operaciones criptográficas y siempre que tenga la app desbloqueada
        guard let accessControl = SecAccessControlCreateWithFlags(nil, kSecAttrAccessibleWhenUnlockedThisDeviceOnly, .biometryAny, &accessControlError) else {
            print("Error: could not create access control with error \(String(describing: accessControlError))")
            return nil
        }
        return accessControl
    }
}

// MARK: - Authentication Mock


//FIXME: Sinceramente esto lo busqué
final class AuthenticationMock: AuthenticationProtocol{
    // No necesitamos un context ya que es una simulación, no trabaja con la biometría real
    // Context que existe pero nunca se usa para biometría real
       let context = LAContext()
    
    // Propiedades configurables para tests
    var shouldAuthenticationSucceed = true // ¿debe tener éxito la autenticación?
    var shouldAccessControlSucceed = true // ¿debe crearse correctamente el AccessControl?
    var authenticationDelay: TimeInterval = 0.0 //  retardo simulado (segundos) antes de llamar a completion
    var mockError: NSError?
    
    // Para verificar que se llamaron los métodos en tests
    var authenticateUserCallCount = 0
    var getAccessControlCallCount = 0
    
    func authenticateUser(completion: @escaping (Bool) -> Void) {
        authenticateUserCallCount += 1
        
        let executeCompletion = {
            DispatchQueue.main.async {
                completion(self.shouldAuthenticationSucceed)
            }
        }
        
        // Si se configuró un retardo, simulamos latencia (biometría/usuario)
        if authenticationDelay > 0 {
            DispatchQueue.global().asyncAfter(deadline: .now() + authenticationDelay) {
                executeCompletion()
            }
        } else {
            executeCompletion()
        }
    }
    
    /// Devuelve un SecAccessControl válido pero no exige FaceID/TouchID
    ///    - SecAccessControlCreateWithFlags -> crea una política de acceso para Keychain
    ///    - kSecAttrAccessibleWhenUnlockedThisDeviceOnly -> accesible con el dispositivo desbloqueado y no migra a otros dispositivos
    ///    -   [ ] -> sin flags de biometría (más estable en simulador/tests)
    
    func getAccessControl() -> SecAccessControl? {
        getAccessControlCallCount += 1
        
        if shouldAccessControlSucceed {
            // Lo dejo aqui a pesar de que el KeyChainHelperMock no usa un keychain real. Pero lo dejo como documentación
            // Crear un SecAccessControl real pero simple para testing
            var error: Unmanaged<CFError>?
            return SecAccessControlCreateWithFlags(
                nil,
                kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                [], //Sin usar biometria  para testing
                &error
            )
        } else {
            return nil
        }
        
    }
    
    func reset() {
        shouldAuthenticationSucceed = true
        shouldAccessControlSucceed = true
        authenticationDelay = 0.0
        authenticateUserCallCount = 0
        getAccessControlCallCount = 0
    }
    
    func simulateFailure() {
        shouldAuthenticationSucceed = false
    }
    func simulateSuccess() {
        shouldAuthenticationSucceed = true
    }
    
    
    
}
