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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //searchTableView.tableFooterView
    }


}

//MARK: tableView related
extension SearchBooksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

