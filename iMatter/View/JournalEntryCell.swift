//
//  JournalEntryCell.swift
//  iMatter
//
//  Created by Mycah on 2/21/20.
//  Copyright © 2020 Mycah Krason. All rights reserved.
//

import UIKit

class JournalEntryCell: UITableViewCell {

    
    @IBOutlet weak var entryDateDisplay: UILabel!
    @IBOutlet weak var enteredMoodDisplay: UIImageView!
    @IBOutlet weak var entryContentDisplay: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
}
