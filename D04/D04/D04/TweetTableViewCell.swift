//
//  TweetTableViewCell.swift
//  D04
//
//  Created by Antoine JOUANNAIS on 4/18/17.
//  Copyright © 2017 Antoine JOUANNAIS. All rights reserved.
//

import UIKit

class
TweetTableViewCell: UITableViewCell {

    

    @IBOutlet weak var titre: UILabel!

    @IBOutlet weak var dateTweet: UILabel!
   
    @IBOutlet weak var contenu: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
