//
//  FavoritePhotoTableViewCell.swift
//  WhatsThat
//
//  Created by 李腾 on 11/20/17.
//  Copyright © 2017 李腾. All rights reserved.
//

import UIKit

class FavoritePhotoTableViewCell: UITableViewCell {
    @IBOutlet weak var photoIdenText: UILabel!
    
    @IBOutlet weak var favrImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
