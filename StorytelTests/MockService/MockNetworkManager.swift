//
//  MockNetworkManager.swift
//  StorytelTests
//
//  Created by Christian on 21/04/19.
//  Copyright © 2019 Christian. All rights reserved.
//

import Foundation
@testable import Storytel


class MockNetworkManager: StorytelAPINetworkProtocol {
    
    var mockQueryBooksResponse: QueryBooksResponse?
    var mockError: String?
    
    required init(environment: NetworkEnvironment) {
    }
    
    
    func searchBooks(query: String, page: String, completion: @escaping (QueryBooksResponse?, String?) -> ()) {
        completion(mockQueryBooksResponse, mockError)
    }
}
