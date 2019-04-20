//
//  SearchBooksViewController.swift
//  Storytel
//
//  Created by Christian on 19/04/19.
//  Copyright © 2019 Christian. All rights reserved.
//

import UIKit

class SearchBooksViewController: UIViewController {
    @IBOutlet var searchTableView: UITableView!
    @IBOutlet var loadingView: UIActivityIndicatorView!
    private let refreshControl = UIRefreshControl()
    @IBOutlet var errorView: UIView!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var errorViewBottomConstraint: NSLayoutConstraint!
    
    var searchBooksViewModel = SearchBooksViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //searchTableView.tableFooterView
        initView()
        initViewModel()
    }

}

//MARK: viewModel related
extension SearchBooksViewController {
    private func initViewModel() {
        searchBooksViewModel.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.searchTableView.reloadData()
            }
        }
        searchBooksViewModel.insertToTableViewClosure = insertToTableView(start:end:)
        searchBooksViewModel.showSearchErrorClosure = { [weak self] (error) in
            DispatchQueue.main.async {
                self?.showSearchError(error)
            }
        }
        searchBooksViewModel.showLoadingViewCLosure = { [weak self] (isLoading) in
            DispatchQueue.main.async {
                self?.showLoadingView(isLoading)
            }
        }
        
        searchBooksViewModel.refreshSearchBooks()
    }
}

//MARK: private func
extension SearchBooksViewController {
    private func initView() {
        initTableView()
        
        errorViewBottomConstraint.constant = errorView.bounds.height
        self.view.layoutIfNeeded()
    }
    
    private func showSearchError(_ error: String) {
        errorLabel.text = error.localized()
        errorViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }) { [weak self] (_) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self?.hideErrorView()
            })
        }
    }
    private func hideErrorView() {
        errorViewBottomConstraint.constant = errorView.bounds.height
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func showLoadingView(_ isLoading: Bool) {
        searchTableView.tableFooterView?.isHidden = !isLoading
        if isLoading {
            loadingView.startAnimating()
        } else {
            loadingView.stopAnimating()
            refreshControl.endRefreshing()
        }
    }
}


//MARK: tableView related
extension SearchBooksViewController: UITableViewDelegate, UITableViewDataSource {
    private func initTableView() {
        searchTableView.register(UINib(nibName: "QueryViewCell", bundle: nil), forCellReuseIdentifier: "QueryViewCell")
        searchTableView.register(UINib(nibName: "BookViewCell", bundle: nil), forCellReuseIdentifier: "BookViewCell")
        
        refreshControl.addTarget(self, action:
            #selector(handleReshresh(_:)),
                                 for: UIControl.Event.valueChanged)
        
        refreshControl.tintColor = UIColor.blue
        searchTableView.addSubview(refreshControl)
        
        searchTableView.tableFooterView = loadingView
        loadingView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: loadingView.bounds.height)
        searchTableView.tableFooterView?.isHidden = true
    }
    
    @objc private func handleReshresh(_ refreshControl: UIRefreshControl?) {
        searchBooksViewModel.refreshSearchBooks()
    }
    
    private func insertToTableView(start: Int, end: Int) {
        var indexPaths = [IndexPath]()
        for index in start..<end {
            indexPaths.append(IndexPath(row: index, section: 0))
        }
        DispatchQueue.main.async { [weak self] in
            self?.searchTableView.performBatchUpdates({
                self?.searchBooksViewModel.updateDataCountForInsertion(start: start, end: end)
                self?.searchTableView.insertRows(at: indexPaths, with: .automatic)
            }, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchBooksViewModel.currentDataCount + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        if index == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QueryViewCell", for: indexPath) as! QueryViewCell
            cell.configureCell(query: searchBooksViewModel.query)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookViewCell", for: indexPath) as! BookViewCell
            cell.configureCell(model: searchBooksViewModel.getBookCellViewModel(at: index - 1))
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("userSelected cell at index: \(indexPath.row)")
    }
}

