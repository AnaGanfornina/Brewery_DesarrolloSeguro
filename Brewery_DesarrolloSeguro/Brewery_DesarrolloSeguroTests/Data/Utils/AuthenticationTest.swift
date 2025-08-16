//
//  AuthenticationTest.swift
//  Brewery_DesarrolloSeguroTests
//
//  Created by Ana on 16/8/25.
//

import XCTest
@testable import Brewery_DesarrolloSeguro

final class AuthenticationTest: XCTestCase {
    var sut: AuthenticationMock!
    var viewModel: BreweryViewModel!
    
    override func setUpWithError() throws {
        sut = AuthenticationMock()
        viewModel = BreweryViewModel(authentication: sut)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        sut = nil
        super.tearDown()
    }
    
    func test_Authentication_Success() {
        // Given
        sut.shouldAuthenticationSucceed = true
        let expectation = XCTestExpectation(description: "Authentication should succeed")
        
        // When
        sut.authenticateUser { success in
            // Then
            XCTAssertTrue(success)
            XCTAssertEqual(self.sut.authenticateUserCallCount, 1)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }

    func test_Authentication_Failure() {
           // Given
           sut.simulateFailure() // ← Más simple
           let expectation = XCTestExpectation(description: "Authentication should fail")
           
           // When
           sut.authenticateUser { success in
               // Then
               XCTAssertFalse(success)
               expectation.fulfill()
           }
           
           wait(for: [expectation], timeout: 1.0)
       }
    
    func test_GetAccessControl_Success() {
           // Given - Mock ya configurado por defecto para éxito
           
           // When
           let accessControl = sut.getAccessControl()
           
           // Then
           XCTAssertNotNil(accessControl)
           XCTAssertEqual(sut.getAccessControlCallCount, 1)
       }
    
    func testGetAccessControlFailure() {
           // Given
           sut.shouldAccessControlSucceed = false
           
           // When
           let accessControl = sut.getAccessControl()
           
           // Then
           XCTAssertNil(accessControl)
       }
       

}
