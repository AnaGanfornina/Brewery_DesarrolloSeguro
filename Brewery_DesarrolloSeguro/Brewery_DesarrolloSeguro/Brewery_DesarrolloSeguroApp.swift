//
//  Brewery_DesarrolloSeguroApp.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 20/6/25.
//

import SwiftUI

@main
struct Brewery_DesarrolloSeguroApp: App {
    var body: some Scene {
        WindowGroup {
            //BreweriesView(viewModel: BreweryViewModel(useCase: BreweriesUseCase()))
            PrincipalView()
                .environment(AppState())
        }
    }
}
