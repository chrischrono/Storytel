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
    private var loadingView: UIActivityIndicatorView!
    private let refreshControl = UIRefreshControl()
    private var errorView: UIView!
    private var errorLabel: UILabel!
    private var errorViewBottomConstraint: NSLayoutConstraint!
    
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
        searchBooksViewModel.showEditSearchQueryClosure = showEditSearchQuery
        
        searchBooksViewModel.refreshSearchBooks()
    }
}

//MARK: tableView related
extension SearchBooksViewController: UITableViewDelegate, UITableViewDataSource {
    private func initTableView() {
        searchTableView = BasicUI.createTableView(dataSource: self, delegate: self)
        searchTableView.register(UINib(nibName: "QueryViewCell", bundle: nil), forCellReuseIdentifier: "QueryViewCell")
        searchTableView.register(UINib(nibName: "BookViewCell", bundle: nil), forCellReuseIdentifier: "BookViewCell")
        view.addSubview(searchTableView)
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            searchTableView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            searchTableView.heightAnchor.constraint(equalTo: safeArea.heightAnchor),
            searchTableView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            searchTableView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
            ])
        
        refreshControl.addTarget(self, action:
            #selector(handleReshresh(_:)),
                                 for: UIControl.Event.valueChanged)
        
        refreshControl.tintColor = UIColor.blue
        searchTableView.addSubview(refreshControl)
        
        loadingView = BasicUI.createActivityIndicator(style: .whiteLarge, color: "E75B0C")
        loadingView.translatesAutoresizingMaskIntoConstraints = true
        loadingView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: loadingView.bounds.height)
        searchTableView.tableFooterView = loadingView
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
        let index = indexPath.row
        
        if index == 0 {
            searchBooksViewModel.userRequestEditSearchQuery()
        } else {
            print("userSelected cell at index: \(index - 1)")
        }
        
    }
}


//MARK: private func
extension SearchBooksViewController {
    private func initView() {
        initTableView()
        
        errorView = BasicUI.createView()
        view.addSubview(errorView)
        errorViewBottomConstraint = errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 60)
        NSLayoutConstraint.activate([
            errorView.widthAnchor.constraint(equalTo: view.widthAnchor),
            errorView.heightAnchor.constraint(equalToConstant: 60),
            errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorViewBottomConstraint
            ])
        
        errorLabel = BasicUI.createLabel(text: "Error")
        errorView.addSubview(errorLabel)
        NSLayoutConstraint.activate([
            errorLabel.widthAnchor.constraint(equalTo: errorView.widthAnchor, constant: -40),
            errorLabel.centerXAnchor.constraint(equalTo: errorView.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: errorView.centerYAnchor)
            ])
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
    
    private func showEditSearchQuery() {
        let alertController = UIAlertController(title: "dialogbox_new_query_title".localized(), message: nil, preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "general_search".localized(), style: .default) { (_) in
            
            //getting the input values from user
            let query = alertController.textFields?[0].text
            if let query = query, query.count > 0 {
                self.searchBooksViewModel.query = query
            }
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "general_cancel".localized(), style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "dialogbox_new_query_placeholder".localized()
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
}
