//
//  WikipediaResult.swift
//  WhatsThat
//
//  Created by 李腾 on 11/12/17.
//  Copyright © 2017 李腾. All rights reserved.
//

import Foundation
import UIKit

class WikipediaResult: NSObject {
    let title: String
    let content: String
    let imageName: String
    let locations: [Double]
    
    let titleKey = "title"
    let contentKey = "contentKey"
    let imageNameKey = "imageNameKey"
    let locationsKey = "locationsKey"
    

    init(title: String, content: String, imageName: String, locations: [Double]){
        self.title = title
        self.content = content
        self.imageName = imageName
        self.locations = locations
    }
    
    required init?(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObject(forKey: titleKey) as? String ?? ""
        content = aDecoder.decodeObject(forKey: contentKey) as? String ?? ""
        imageName = aDecoder.decodeObject(forKey: imageNameKey) as? String ?? ""
        locations = aDecoder.decodeObject(forKey: locationsKey) as? [Double] ?? []
    }
}

extension WikipediaResult: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: titleKey)
        aCoder.encode(content, forKey: contentKey)
        aCoder.encode(imageName, forKey: imageNameKey)
        aCoder.encode(locations, forKey: locationsKey)
    }
}
