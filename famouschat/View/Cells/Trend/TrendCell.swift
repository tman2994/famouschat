//
//  TrendCell.swift
//  famouschat
//
//  Created by Oni Angel on 07/11/2018.
//  Copyright © 2018 Oni Angel. All rights reserved.
//

import UIKit

class TrendCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var bio: UILabel!
    @IBOutlet weak var like: UILabel!
    @IBOutlet weak var star_img: UIImageView!
    @IBOutlet weak var category_length: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let image = UIImage.init(named: "star")?.withRenderingMode(.alwaysTemplate)
        star_img.image = image
        star_img.tintColor = Utility.color(withHexString: ShareData.star_color)
    }


    override func prepareForReuse() {
        
        photo.image = UIImage.init(named: "non_profile")
        super.prepareForReuse()
        
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
