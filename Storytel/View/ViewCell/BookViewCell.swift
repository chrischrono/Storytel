//
//  BookViewCell.swift
//  Storytel
//
//  Created by Christian on 19/04/19.
//  Copyright © 2019 Christian. All rights reserved.
//

import UIKit
import Kingfisher

class BookViewCell: UITableViewCell {
    
    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var narratorLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(model: BookCellViewModel?) {
        if let model = model {
            coverImageView.kf.setImage(with: URL(string: model.coverUrl))
            coverImageView.alpha = 1
            titleLabel.text = model.title
            authorLabel.text = "book_view_cell_by".localized() + model.author
            narratorLabel.text = "book_view_cell_with".localized() + model.narrator
        } else {
            coverImageView.image = nil
            coverImageView.alpha = 0
            titleLabel.text = "Query book not found"
            authorLabel.text = nil
            narratorLabel.text = nil
        }
    }
    
}
