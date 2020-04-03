//
//  SocialCell.swift
//  famouschat
//
//  Created by Oni Angel on 09/11/2018.
//  Copyright © 2018 Oni Angel. All rights reserved.
//

import UIKit

class SocialCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var go_img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var left_constrain: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        
        img.image = UIImage.init(named: "non_profile")
        super.prepareForReuse()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
