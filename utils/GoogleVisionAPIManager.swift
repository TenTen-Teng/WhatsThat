//
//  GoogleVisionAPIManager.swift
//  WhatsThat
//
//  Created by 李腾 on 11/12/17.
//  Copyright © 2017 李腾. All rights reserved.
//

import Foundation
import UIKit


protocol IdentificationDelegate {
    func resultsFound(googleVisionResults: [GoogleVisionResult])
    func resultsNotFound(reason: GoogleVisionAPIManager.FailureReason)
}

class GoogleVisionAPIManager {
    var delegate: IdentificationDelegate?
    let apiKey = "AIzaSyB8Vli_gGzOfI1hlj5sEYNdYwE3OEMRegU"
    
    enum FailureReason: String {
        case networkRequestFailed = "Your request failed, please try again."
        case noData = "No wiki data received"
        case badJSONResponse = "Bad JSON response"
    }
    
    func fetchGoogleVisionResults(image: UIImage)
    {
        
        let base64image = UIImageJPEGRepresentation(image, 0.8)?.base64EncodedString()
        
        var urlComponents = URLComponents(string: "https://vision.googleapis.com/v1/images:annotate")!
        
        urlComponents.queryItems = [URLQueryItem(name: "key", value: apiKey)]
        
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let jsonRequest: [String: Any] = [
            "requests": [
                "image" : ["content" : base64image],
                "features" : [["type" : "LABEL_DETECTION"]]
            ]
        ]
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: jsonRequest, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            //check for valid response with 200 (success)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                self.delegate?.resultsNotFound(reason: .networkRequestFailed)
                
                return
            }
            
            //ensure data is non-nil
            guard let data = data else {
                self.delegate?.resultsNotFound(reason: .noData)
                
                return
            }
            
            let decoder = JSONDecoder()
            let decodedRoot = try? decoder.decode(Root.self, from: data)
            
            guard let root = decodedRoot else {
                self.delegate?.resultsNotFound(reason: .badJSONResponse)
                
                return
            }
            
            let responses = root.responses
            
            var googleVisionResults = [GoogleVisionResult]()
            for label in responses {
                let labels = label.labelAnnotations
                for item in labels {
                    let googleVisionResult = GoogleVisionResult(mid: item.mid, description: item.description, score: String(item.score))
                    googleVisionResults.append(googleVisionResult)
                }
            }
            
            self.delegate?.resultsFound(googleVisionResults: googleVisionResults)
        }
        
        task.resume()
    }
}
