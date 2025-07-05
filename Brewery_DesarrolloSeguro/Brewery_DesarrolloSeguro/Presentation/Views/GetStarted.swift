//
//  GetStarted.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 26/6/25.
//

import SwiftUI

struct GetStarted: View {
    @Environment(AppState.self) var appState
    var body: some View {
        VStack{
            Text("Hazte con todos")
                .font(.title)

            
            //boton de "Login"
            Button {
                appState.loginApp()
                
                //NSLocalizedString("LOGIN_BUTTON", comment: "Entrar22")
            } label: {
                Text("Get started")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .frame(width: 300, height: 50)
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 10.0, x:5, y:10)
            }
        }
    }
}

#Preview {
    GetStarted()
        .environment(AppState())
}
