//
//  GetStarted.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 11/8/25.
//

import SwiftUI

struct GetStarted: View {
    
    var viewModel: BreweryViewModel
    var body: some View {
        VStack{
            Text("Hazte con todos!")
                .font(.title)
            
            Button{
                //acción
                EncryptionManager.shared.generateNewKey()
                
                viewModel.keyAuthentication = KeychainHelper.keychain.readKeyWithAutentication(authentication: viewModel.authentication)
            }label: {
                Text("Get Started")
                    .font(.custom("Copperplate-Bold", size: 20))
                    .foregroundColor(.black)
                    .padding(20)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .background(
                        ZStack {
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.95, green: 0.89, blue: 0.78),
                                    Color(red: 0.82, green: 0.63, blue: 0.27)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            
                            RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [.black, .black],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        }
                    )
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.25), radius: 5, x: 3, y: 3)
                    .padding()
                
                
            }
        }
        
    }
}

#Preview {
    GetStarted(viewModel: BreweryViewModel(useCase: BreweriesUseCaseMock(),
                                                      authentication: Authentication(context: AppState().authenticationContext)))
}
