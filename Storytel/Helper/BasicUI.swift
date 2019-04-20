//
//  ViewCreator.swift
//  Storytel
//
//  Created by Christian on 20/04/19.
//  Copyright © 2019 Christian. All rights reserved.
//

import Foundation
import UIKit


struct BasicUI {
    static func createView(color: String = "FFFFFF", alpha: CGFloat = 1) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: color)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    static func createLabel(text: String, font: UIFont = UIFont.systemFont(ofSize: 15), alignment: NSTextAlignment = .left, color: String = "000000") -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textAlignment = alignment
        label.textColor = UIColor(hexString: color)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func createActivityIndicator(style: UIActivityIndicatorView.Style = .gray, color: String = "000000") -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: style)
        activityIndicator.color = UIColor(hexString: color)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }
    
    static func createTableView(dataSource: UITableViewDataSource? = nil, delegate: UITableViewDelegate? = nil) -> UITableView {
        let tableView = UITableView()
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }
    
}
