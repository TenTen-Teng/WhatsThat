//
//  PhotoIdentificationTableViewCell.swift
//  WhatsThat
//
//  Created by 李腾 on 11/27/17.
//  Copyright © 2017 李腾. All rights reserved.
//

import UIKit

class PhotoIdentificationTableViewCell: UITableViewCell {
    

    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

