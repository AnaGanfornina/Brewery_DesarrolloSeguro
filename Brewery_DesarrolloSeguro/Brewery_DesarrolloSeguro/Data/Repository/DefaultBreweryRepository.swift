//
//  DefaultBreweryRepository.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 20/6/25.
//

import Foundation

// MARK: - BreweryRepository

final class BreweryRepository: BreweryRepositoryProtocol {
    
    private var network: NetworkBreweriesProtocol
    
    init(network: NetworkBreweriesProtocol = NetworkBreweries()) {
        self.network = network
    }
    
    func getBreweries() async -> [Brewery] {
        return await network.getBreweries()
    }
}


// MARK: - BreweryRepository Mock

final class BreweryRepositoryMock: BreweryRepositoryProtocol {
    
    private var network: NetworkBreweriesProtocol
    
    init(network: NetworkBreweriesProtocol = NetworkBreweriesMock()) {
        self.network = network
    }
    
    func getBreweries() async -> [Brewery] {
        return await network.getBreweries()
    }
}
