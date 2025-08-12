//
//  GetStarted.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 11/8/25.
//

import SwiftUI

struct GetStarted: View {
    
    @Binding var viewModel: BreweryViewModel
    var body: some View {
        VStack{
            Text("Hazte con todos!")
                .font(.title)
            
            Button{
                //acción
                UserDefaultsHelper.defaults.generateNewKey()
                viewModel.keyState = KeychainHelper.keychain.readKey()
            }label: {
                Text("Get Started")
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .font(.title3)
                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
            }
        }
        
    }
}

#Preview {
    GetStarted(viewModel: .constant(BreweryViewModel(useCase: BreweriesUseCaseMock())))
}
