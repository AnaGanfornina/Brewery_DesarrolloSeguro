//
//  RootView.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 26/6/25.
//

import SwiftUI

struct RootView: View {
    @Environment(AppState.self) var appState
    
    var body: some View {
        switch (appState.status){
        case .none:
            GetStarted()

        case .loading:
            LoaderView()
              
        case .error(error: let errorString):
            
               ErrorView(error: errorString)
            
        case .loaded:
            PrincipalView() //es la home...
        }
    }
}

#Preview {
    RootView()
        .environment(AppState())
}
