//
//  SearchBooksViewModelTests.swift
//  StorytelTests
//
//  Created by Christian on 21/04/19.
//  Copyright © 2019 Christian. All rights reserved.
//

import XCTest
@testable import Storytel

class SearchBooksViewModelTests: XCTestCase {
    
    var searchBooksViewModel = SearchBooksViewModel()
    var mockNetworkManager = MockNetworkManager(environment: .qa)

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        searchBooksViewModel.networkManager = mockNetworkManager
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testSearchBooksError() {
        mockNetworkManager.mockQueryBooksResponse = nil
        mockNetworkManager.mockError = "This is an error"
        
        searchBooksViewModel.refreshSearchBooks()
        XCTAssertEqual(searchBooksViewModel.status, mockNetworkManager.mockError)
    }
    
    func testSearchBooks() {
        let data = loadDataFromBundle(withName: "search", extension: "json")
        let queryBooksResponse = try! JSONDecoder().decode(QueryBooksResponse.self, from: data)
        mockNetworkManager.mockQueryBooksResponse = queryBooksResponse
        mockNetworkManager.mockError = nil
        
        searchBooksViewModel.query = queryBooksResponse.query
        
        XCTAssertEqual(searchBooksViewModel.currentDataCount, 10)
    }

}
