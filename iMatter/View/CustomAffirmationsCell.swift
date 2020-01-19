//
//  CustomAffirmationsCell.swift
//  iMatter
//
//  Created by Mycah on 11/18/19.
//  Copyright © 2019 Mycah Krason. All rights reserved.
//

import UIKit

protocol AffirmationsCellDelegate{
    //Add functions for the view controller
    func favoriteBtnSelected(cell: UITableViewCell)
}

class CustomAffirmationsCell: UITableViewCell {

    @IBOutlet weak var affirmationsDescription: UILabel!
    @IBOutlet weak var favoriteBtnDisplay: UIImageView!
    @IBOutlet weak var audioTimeDisplay: UILabel!
    
    var delegate: AffirmationsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func starButtonPressed(_ sender: UIButton) {
        
        delegate?.favoriteBtnSelected(cell: self)
        
    }
}
