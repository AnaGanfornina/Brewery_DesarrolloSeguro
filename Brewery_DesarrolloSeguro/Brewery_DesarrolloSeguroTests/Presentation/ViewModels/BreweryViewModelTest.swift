//
//  BreweryViewModelTest.swift
//  Brewery_DesarrolloSeguroTests
//
//  Created by Ana on 13/8/25.
//

import XCTest

@testable import Brewery_DesarrolloSeguro

final class BreweryViewModelTest: XCTestCase {
    var sut: BreweryViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        KeychainHelper.keychain.deleteBrewery()
        sut = BreweryViewModel(useCase: BreweriesUseCaseMock())
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_getBreweries() async throws {
        
        // Given
        // Usamod una expectation para esperar a que nos informe de los cambios de estado el viewModel
        
        var expectedBreweries: [Brewery] = []
        
        
        
        // When
        
        let expectation = expectation(description: "ViewModel load brewery and inform")
        
        Task{
            while sut.beweryData.isEmpty {
                try? await Task.sleep(nanoseconds: 50_000_000) // 0.05s
            }
            expectedBreweries = sut.beweryData
            expectation.fulfill()
        }
        
        
        
        // Then
        
        wait(for: [expectation], timeout: 0.1)
        
        // Como sabemos que el mock devuelve dos breweries
        XCTAssertEqual(sut.beweryData.count, 2)
        let brewery = try XCTUnwrap(sut.beweryData.first)
        let breweryExpected = try XCTUnwrap(expectedBreweries.first)
        
        XCTAssertEqual(brewery.id, breweryExpected.id)
        
        
        // Podemos comprobar datos concretos si queremos
        XCTAssertEqual(sut.beweryData[0].name, "Bière de la Plaine Mock")
        XCTAssertEqual(sut.beweryData[1].name,  "La Minotte Mock")
        
    }
    
    
    
}

// Given

// When

// Then
