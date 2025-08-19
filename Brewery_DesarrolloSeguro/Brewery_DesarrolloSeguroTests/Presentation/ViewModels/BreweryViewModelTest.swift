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
    var authenticationMock: AuthenticationMock!
    let breweryTest = Brewery(
        id: "1",
        name: "Test Brewery",
        breweryType: "TestType",
        address1: nil,
        address2: nil,
        address3: nil,
        city: "TestCity",
        stateProvince: "TestProvince",
        postalCode: "TestPostalColde",
        country: "TestCountry",
        longitude: nil,
        latitude: nil,
        phone: nil,
        websiteURL: nil,
        state: "TestState",
        street: nil
    )
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        authenticationMock = AuthenticationMock()
        KeychainHelper.keychain.deleteBrewery()
        sut = BreweryViewModel(useCase: BreweriesUseCaseMock(),
                               authentication: authenticationMock)
        
        
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_getBreweries() async throws {
        
        // When: llamamos a la función async
        await sut.getBreweries()
        
        // Then: comprobamos el resultado
        XCTAssertEqual(sut.beweryData.count, 2)
        let brewery = try XCTUnwrap(sut.beweryData.first)
        XCTAssertEqual(brewery.name, "Bière de la Plaine Mock")
        
        let secondBrewery = try XCTUnwrap(sut.beweryData.last)
        XCTAssertEqual(secondBrewery.name, "La Minotte Mock")
        
    }
    
    func test_AddFavorite_WithSuccessfulAuth() {
        // Given
        authenticationMock.simulateSuccess()
        let expectation = XCTestExpectation(description: "Favorite added")
        
        // When
        sut.addFavorite(breweryTest)
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.authenticationMock.authenticateUserCallCount, 1)
            XCTAssertFalse(self.sut.showAlertFavorite)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testAddFavoriteWithFailedAuth(){
        // Given
        authenticationMock.simulateFailure()
        let expectation = XCTestExpectation(description: "Test BreweryFailed Authentication")

        // When
        sut.addFavorite(breweryTest)

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            XCTAssertEqual(self.authenticationMock.authenticateUserCallCount, 1)
            XCTAssertTrue(self.sut.showAlertFavorite)
            expectation.fulfill()
            
        }
        wait(for: [expectation], timeout: 1.0)

    }
    
    
    
    
    
}

// Given

// When

// Then
