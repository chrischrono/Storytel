//
//  TableViewDataManager.swift
//  Storytel
//
//  Created by Christian on 19/04/19.
//  Copyright © 2019 Christian. All rights reserved.
//

import Foundation




protocol TableViewDataManager: class {
    var currentDataCount: Int { get }
    func updateDataCountForInsertion(start: Int, end: Int)
}
