//
//  BookCellViewModel.swift
//  Storytel
//
//  Created by Christian on 19/04/19.
//  Copyright © 2019 Christian. All rights reserved.
//

import Foundation


class BookCellViewModel {
    let id: String
    let coverUrl: String
    let title: String
    let author: String
    let narrator: String
    
    init(with book: Book) {
        id = book.id
        coverUrl = book.cover.url
        title = book.title
        author = book.authors.map({ (author) -> String in
            return author.name
        }).joined(separator: ", ")
        narrator = book.narrators.map({ (narrator) -> String in
            return narrator.name
        }).joined(separator: ", ")
    }
}
