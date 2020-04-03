//
//  FeedPhotoCell.swift
//  famouschat
//
//  Created by Oni Angel on 06/11/2018.
//  Copyright © 2018 Oni Angel. All rights reserved.
//

import UIKit

class FeedPhotoCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var message: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
