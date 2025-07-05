//
//  Logger.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 26/6/25.
//

import Foundation
import OSLog

class AppLogger {
    // El subsystem en logging permite filtrar y separar los logs de diferentes orígenes (apps, sistema, frameworks) evitando que se mezclen, facilitando la identificación y depuración de los registros específicos de la aplicación. Normalmente se aconseja poner un nombre como com.ismaelsabri.desarrolloseguroiosapp
    private static let subsystem = "com.anaganfornina.Brewery"
    
    // Cada vez que creemos un logger se añade al diccionario de loggerCache para que no se repitan y se use una única instancia por cada categoría
    private static var loggerCache: [String: Logger] = [:]
    
    
    private static func getLogger(category: String) -> Logger {
        guard let logger = loggerCache[category] else {
            loggerCache[category] = Logger(subsystem: subsystem, category: category)
            return loggerCache[category]!
        }
        return logger
    }
}
