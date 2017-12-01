//
//  SearchTimelineTableViewController.swift
//  WhatsThat
//
//  Created by 李腾 on 11/20/17.
//  Copyright © 2017 李腾. All rights reserved.
//

import UIKit
import TwitterKit

class SearchTimelineTableViewController: TWTRTimelineViewController{
    
    var query = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(query)
        
        dataSource = TWTRSearchTimelineDataSource(searchQuery: query, apiClient: TWTRAPIClient())
    }
}

