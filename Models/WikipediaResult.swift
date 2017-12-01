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
    
    let titleKey = "title"
    let contentKey = "contentKey"
    
    init(title: String, content: String) {
        self.title = title
        self.content = content
    }
    
    required init?(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObject(forKey: titleKey) as? String ?? ""
        content = aDecoder.decodeObject(forKey: contentKey) as? String ?? ""
    }
}

extension WikipediaResult: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: titleKey)
        aCoder.encode(content, forKey: contentKey)
    }
}

