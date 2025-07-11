//
//  BreweriesUseCase.swift
//  Brewery_DesarrolloSeguro
//
//  Created by Ana on 20/6/25.
//

// MARK: - Protocol

protocol BreweriesUseCaseProtocol {
    var repo: BreweryRepositoryProtocol{get set}
    
    func getBreweries() async -> [Brewery]
    func addFavorites(_ brewery: Brewery)
    func getFavoriteBreweries() -> [Brewery]
    
}

// MARK: -  BreweriesUseCase

final class BreweriesUseCase: BreweriesUseCaseProtocol{
    
    var repo: any BreweryRepositoryProtocol
    
    init(repo: BreweryRepository = BreweryRepository()) {
        self.repo = repo
    }
    func getBreweries() async -> [Brewery] {
        await repo.getBreweries()
    }
    func addFavorite(_ brewery: Brewery) {
        repo.addFavorites(brewery)
    }
    
    func getFavoriteBreweries() -> [Brewery] {
        repo.getFavoriteBreweries()
    }
    
}

// MARK: -  BreweriesUseCase Mock

final class BreweriesUseCaseMock: BreweriesUseCaseProtocol{
   
    
    var repo: any BreweryRepositoryProtocol
    
    init(repo: BreweryRepositoryProtocol = BreweryRepositoryMock()) {
        self.repo = repo
    }
    func getBreweries() async -> [Brewery] {
        await repo.getBreweries()
    }
    
    func addFavorite(_ brewery: Brewery) {
        repo.addFavorites(brewery)
    }
    
    func getFavoriteBreweries() -> [Brewery] {
        repo.getFavoriteBreweries()
    }
    
}
