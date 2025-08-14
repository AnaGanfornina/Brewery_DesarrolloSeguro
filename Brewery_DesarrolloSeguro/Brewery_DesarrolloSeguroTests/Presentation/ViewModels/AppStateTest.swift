//
//  AppStateTest.swift
//  Brewery_DesarrolloSeguroTests
//
//  Created by Ana on 14/8/25.
//

import XCTest

@testable import Brewery_DesarrolloSeguro
final class AppStateTest: XCTestCase {
    var sut: AppState!

    override func setUpWithError() throws {
        try super.setUpWithError()
       
        sut = AppState()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
 
    
    func test_loginApp() throws {
        // Given
        sut.status = Status.none
        let expectation = expectation(description: "Login isOk")
        
        // Observamos el cambio de estado
        DispatchQueue.global().async {
               while self.sut.status != .loaded { }
               expectation.fulfill()
           }

        // When
        sut.loginApp()

        // Then
        wait(for: [expectation], timeout: 4.0) // lo ponemos en 4 ya que el login tarda 2 segundos en hacerse
        XCTAssertEqual(sut.status, .loaded)
    }

   

}


// Given

// When

// Then
