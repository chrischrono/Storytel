//
//  QueryViewCell.swift
//  Storytel
//
//  Created by Christian on 19/04/19.
//  Copyright © 2019 Christian. All rights reserved.
//

import UIKit

class QueryViewCell: UITableViewCell {
    
    @IBOutlet var queryLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(query: String) {
        queryLabel.text = "Query: \(query)"
    }
    
}
