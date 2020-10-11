//
//  ArticleCell.swift
//  iMatter
//
//  Created by Mycah on 1/21/20.
//  Copyright © 2020 Mycah Krason. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {

    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
