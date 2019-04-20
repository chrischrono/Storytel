//
//  SearchBooksViewModel.swift
//  Storytel
//
//  Created by Christian on 19/04/19.
//  Copyright © 2019 Christian. All rights reserved.
//

import Foundation


class SearchBooksViewModel {
    var query = "harry" {
        didSet {
            refreshSearchBooks()
        }
    }
    private var books = [Book]()
    private var totalCount = Int.max
    private var nextPage: String?
    private(set) var bookCellViewModels = [BookCellViewModel]() {
        didSet{
            reloadTableViewClosure?()
        }
    }
    
    private(set) var currentDataCount = 0
    private(set) var status: String?
    private var currRequestedPage: String?
    private(set) var isLoading = false {
        didSet {
            showLoadingViewCLosure?(isLoading)
        }
    }
    
    var networkManager: StorytelAPINetworkProtocol = StorytelAPINetworkManager(environment: .production)
    
    var reloadTableViewClosure: (()->())?
    var insertToTableViewClosure: ((Int, Int)->())?
    var showSearchErrorClosure: ((String)->())?
    var showLoadingViewCLosure: ((Bool)->())?
    var showEditSearchQueryClosure: (()->())?
    
    func userRequestEditSearchQuery() {
        showEditSearchQueryClosure?()
    }
}

//MARK:- searchBooks related
extension SearchBooksViewModel {
    
    func refreshSearchBooks() {
        searchBooks(query: query, page: "")
    }
    
    func loadNextPage() {
        searchBooks(query: query, page: nextPage)
    }
    
    func searchBooks(query: String, page: String?) {
        guard let page = page, currRequestedPage == nil else {
            return
        }
        
        currRequestedPage = page
        isLoading = true
        networkManager.searchBooks(query: query, page: page) { [weak self] (queryBooksResponse, error) in
            guard let self = self else {
                return
            }
            self.currRequestedPage = nil
            self.isLoading = false
            guard error == nil else {
                self.showSearchErrorClosure?(error!)
                return
            }
            guard let queryBooksResponse = queryBooksResponse else {
                return
            }
            
            self.processQueryBooksResponse(queryBooksResponse, page: page)
        }
    }
    
    private func processQueryBooksResponse(_ queryBooksResponse: QueryBooksResponse, page: String) {
        nextPage = queryBooksResponse.nextPage
        totalCount = queryBooksResponse.totalCount
        
        let bookCellViewModels = queryBooksResponse.items.map { (book) -> BookCellViewModel in
            return BookCellViewModel(with: book)
        }
        
        if page.count == 0 {
            books = queryBooksResponse.items
            self.bookCellViewModels = bookCellViewModels
            updateDataCountForInsertion(start: 0, end: books.count)
        } else {
            books.append(contentsOf: queryBooksResponse.items)
            let start = self.bookCellViewModels.count
            self.bookCellViewModels.append(contentsOf: bookCellViewModels)
            let end = self.bookCellViewModels.count
            insertToTableViewClosure?(start, end)
        }
    }
}

//MARK:- tableView related
extension SearchBooksViewModel: TableViewDataManager {
    func updateDataCountForInsertion(start: Int, end: Int) {
        currentDataCount = end
    }
    
    func getBookCellViewModel(at index: Int) -> BookCellViewModel? {
        guard index < bookCellViewModels.count else {
            return nil
        }
        
        if index + 5 > bookCellViewModels.count {
            loadNextPage()
        }
        
        return bookCellViewModels[index]
    }
    
}
