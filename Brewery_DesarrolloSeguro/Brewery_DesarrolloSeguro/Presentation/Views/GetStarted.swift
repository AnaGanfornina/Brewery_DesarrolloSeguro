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
    
            
            
            Image("")
                .resizable()
                .frame(height: 200)
                .background(.greenBrewery)

            

            
            Text("BREWERY")
                .font(.custom("Futura", size: 40))
                .fontWeight(.medium)
                .tracking(2)
                .foregroundColor(.goldenText)
                .padding(16)
            
            
            Image("FondoStart")
                .resizable()
                .ignoresSafeArea()
                .background(Color.greenBrewery)
               
        }// VStack  
        .onTapGesture {
            appState.loginApp()
        }
    }
}

#Preview {
    GetStarted()
        .environment(AppState())
}
