//
//  Authentication.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 13/8/25.
//

import Foundation
import LocalAuthentication

class Authentication{
    
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
