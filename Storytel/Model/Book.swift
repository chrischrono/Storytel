//
//  Book.swift
//  Storytel
//
//  Created by Christian on 19/04/19.
//  Copyright © 2019 Christian. All rights reserved.
//

import Foundation

struct QueryBooksResponse: Codable {
    let query: String
    let nextPage: String?
    let totalCount: Int
    let items: [Book]
}


struct Book: Codable {
    let id: String
    let title: String
    let originalTitle: String?
    let type: String
    let description: String
    let authors: [Author]
    let narrators: [Narrator]
    let rating: Float
    let reviewCount: Int
    let cover: ImageSource
    let seriesId: String?
    let seriesName: String?
    let orderInSeries: Int?
    let seasonNumber: Int?
}
