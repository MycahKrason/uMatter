//
//  CustomTrackCell.swift
//  iMatter
//
//  Created by Mycah on 11/26/19.
//  Copyright © 2019 Mycah Krason. All rights reserved.
//

import UIKit

class CustomTrackCell: UITableViewCell {
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var trackNumberDisplay: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
