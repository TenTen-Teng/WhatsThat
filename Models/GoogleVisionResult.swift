//
//  GoogleVisionResult.swift
//  WhatsThat
//
//  Created by 李腾 on 11/12/17.
//  Copyright © 2017 李腾. All rights reserved.
//

import Foundation

struct GoogleVisionResult: Codable {
    let mid: String
    let description: String
    let score: String
    
    enum CodingKeys: String, CodingKey {
        case mid
        case description
        case score
    }
}

