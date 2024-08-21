//
//  CheckedOutBooksTests.swift
//  LibBoulderTests
//
//  Created by Collin Palmer on 8/21/24.
//

import XCTest

@testable import LibBoulder

final class AccountOverviewTests: XCTestCase {
    var viewModel: AccountOverviewViewModel!
    var testData: TestData!

    override func setUpWithError() throws {
        viewModel = AccountOverviewViewModel()
        testData = TestData(bundle: Bundle(for: type(of: self)))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    /// Test that a failed fetch attempts to reauthenticate and fetch again
    func testFetchBooksReauth() async throws {
        class MockLibCatAPI: LibCatAPIRepresentable {
            static let baseURL: URL = LibCatAPI.baseURL
            
            private var firstCallComplete = false
            let testData: TestData
            
            init(testData: TestData) {
                self.testData = testData
            }
            
            func login(cardNumber: String) async throws {}
            
            func fetchCheckedOutBooks() async throws -> CheckedOutBooksModel {
                if firstCallComplete == false {
                    firstCallComplete = true
                    throw URLError(.userAuthenticationRequired)
                } else {
                    return testData.jsonCheckedOut
                }
            }
        }
        
        viewModel.libCatAPI = MockLibCatAPI(testData: testData)
        try await viewModel.fetchBooks(libraryCardNumber: "123")
        XCTAssert(viewModel.books.count == 2)
    }
    
    func testFetchBooks() async throws {
        class MockLibCatAPI: LibCatAPIRepresentable {
            static let baseURL: URL = LibCatAPI.baseURL
            
            let testData: TestData
            
            init(testData: TestData) {
                self.testData = testData
            }
            
            func login(cardNumber: String) async throws {}
            
            func fetchCheckedOutBooks() async throws -> CheckedOutBooksModel {
                return testData.jsonCheckedOut
            }
        }
        
        viewModel.libCatAPI = MockLibCatAPI(testData: testData)
        try await viewModel.fetchBooks(libraryCardNumber: "123")
        
        XCTAssert(viewModel.books.count == 2)
    }
    
    func testRefreshTaskLogout() async throws {
        class MockLibCatAPI: LibCatAPIRepresentable {
            static let baseURL: URL = LibCatAPI.baseURL
            
            let testData: TestData
            
            init(testData: TestData) {
                self.testData = testData
            }
            
            func login(cardNumber: String) async throws {}
            
            func fetchCheckedOutBooks() async throws -> CheckedOutBooksModel {
                throw URLError(.userAuthenticationRequired)
            }
        }
        
        let expectation = XCTestExpectation(description: "logoutController() called")
        viewModel.libCatAPI = MockLibCatAPI(testData: testData)
        viewModel.logoutController = { expectation.fulfill() }
        await viewModel.refreshTask(libraryCardNumber: "123")
        await fulfillment(of: [expectation], timeout: 3)
    }
}
