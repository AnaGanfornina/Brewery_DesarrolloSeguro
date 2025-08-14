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

        XCTAssertEqual(expectedBreweries.count, 50)
        let brewery = try XCTUnwrap(expectedBreweries.first)
        XCTAssertEqual(brewery.name, "(405) Brewing Co")
        XCTAssertEqual(brewery.id, "5128df48-79fc-4f0f-8b52-d06be54d0cec")
        XCTAssertEqual(brewery.breweryType, "micro")
        
    }

}
