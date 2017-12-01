//
//  requestsStructs.swift
//  MBProgressHUD
//
//  Created by 李腾 on 11/27/17.
//

import Foundation

struct Root: Codable {
    let responses: [Responses]
}

struct Responses: Codable {
    let labelAnnotations: [LabelAnnotations]
}

struct LabelAnnotations: Codable {
    let mid: String
    let description: String
    let score: Double
}

