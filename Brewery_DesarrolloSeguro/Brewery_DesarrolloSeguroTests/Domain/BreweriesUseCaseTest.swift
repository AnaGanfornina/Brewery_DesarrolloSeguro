//
//  BreweriesUseCaseTest.swift
//  Brewery_DesarrolloSeguroTests
//
//  Created by Ana on 13/8/25.
//

import XCTest
@testable import Brewery_DesarrolloSeguro

final class BreweriesUseCaseTest: XCTestCase {
    var sut: BreweriesUseCase!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = BreweriesUseCase(repo: BreweryRepositoryMock())
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func test_BreweriesUseCase_ReturnBrewery() async throws {
        // Given
        var expectedBreweries:[Brewery] = []
        
        // When
        expectedBreweries = await sut.getBreweries()
        
        // Then

        XCTAssertEqual(expectedBreweries.count, 2)
        let brewery = try XCTUnwrap(expectedBreweries.first)
        XCTAssertEqual(brewery.name, "Bière de la Plaine Mock")
        XCTAssertEqual(brewery.id, "701239cb-5319-4d2e-92c1-129ab0b3b440")
        XCTAssertEqual(brewery.breweryType, "micro")
        
    }

}
