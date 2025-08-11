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
    func addFavorite(_ brewery: Brewery)
    func deleteFavorite(_ brewery: Brewery)
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
        repo.addFavorite(brewery)
    }
    func deleteFavorite(_ brewery: Brewery){
        repo.deleteFavorite(brewery)
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
        repo.addFavorite(brewery)
    }
    func deleteFavorite(_ brewery: Brewery){
        repo.deleteFavorite(brewery)
    }
    
    func getFavoriteBreweries() -> [Brewery] {
        repo.getFavoriteBreweries()
    }
    
}
