//
//  DiscoverCell.swift
//  famouschat
//
//  Created by Oni Angel on 05/11/2018.
//  Copyright © 2018 Oni Angel. All rights reserved.
//

import UIKit

class DiscoverCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var chanel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        
        image.image = UIImage.init(named: "non_profile")
        super.prepareForReuse()
        
    }

}
