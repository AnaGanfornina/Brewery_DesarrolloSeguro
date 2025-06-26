//
//  ErrorView.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 26/6/25.
//

import SwiftUI

struct ErrorView: View {
    @Environment(AppState.self) var appState
    private var textError: String
    
    init(error: String){
        self.textError = error
    }
    
    var body: some View {
    
        VStack{
            Image(systemName: "exclamationmark.triangle")
                .resizable()
                .foregroundStyle(.red)
                .frame(width: 200, height: 200)
                .padding()
            
            Text(textError)
                .foregroundStyle(.red)
                .font(.headline)
            
            Button {
                //volver al getstarted, cambiando el estado
                appState.status = .none
            } label: {
                Text("Volver")
                    .frame(width: 300, height: 50)
                    .background(.orange)
                    .foregroundStyle(.white)
            }

        }
    }
}

#Preview {
    ErrorView(error: "Error de prueba")
        .environment(AppState())
}
