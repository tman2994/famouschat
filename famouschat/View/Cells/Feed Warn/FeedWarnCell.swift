//
//  FeedWarnCell.swift
//  famouschat
//
//  Created by Oni Angel on 07/11/2018.
//  Copyright © 2018 Oni Angel. All rights reserved.
//

import UIKit

class FeedWarnCell: UITableViewCell {

    @IBOutlet weak var warn_view: UIView!
    @IBOutlet weak var message: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
