//
//  BreweriesView.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 20/6/25.
//

import SwiftUI

struct BreweriesView: View {
    @State var viewModel: BreweryViewModel

    
    var body: some View {
        // lista de cervecería
        List {
            ForEach(viewModel.beweryData){ bewery in
                NavigationLink {
                    // Destination
                } label: {
                    Text(bewery.name)
                }
                
            }
        }
        .refreshable {
            Task{
                await viewModel.getBreweries()
            }
        }
    }
}

#Preview {
    BreweriesView(viewModel: BreweryViewModel(useCase: BreweriesUseCaseMock()))
}
