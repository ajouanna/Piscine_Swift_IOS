//
//  PageTableViewCell.swift
//  D02
//
//  Created by Antoine JOUANNAIS on 4/6/17.
//  Copyright © 2017 Antoine JOUANNAIS. All rights reserved.
//

import UIKit

class PageTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detail: UILabel!  
    @IBOutlet weak var deathDate: UILabel!
    
}
