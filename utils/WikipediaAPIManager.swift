//
//  WikipediaAPIManager.swift
//  WhatsThat
//
//  Created by 李腾 on 11/12/17.
//  Copyright © 2017 李腾. All rights reserved.
//

import Foundation

//protocol for WikiDetailsDelegate results, return a wikiDetails or give failure reason
protocol WikiDetailsDelegate {
    func detailsFound(wikiDetails: WikipediaResult)
    func detailsNotFound(reason: WikipediaAPIManager.FailureReason)
}

class WikipediaAPIManager {
    var delegate: WikiDetailsDelegate?
    
    enum FailureReason: String {
        case networkRequestFailed = "Request failed, please try again!"
        case noData = "No wiki data received"
        case badJSONResponse = "Bad JSON response"
    }
    
    //fetch details from wiki api
    func fetchWikiDetailsResults(keyword: String, imageName: String, locations: [Double])
    {
        //end-point url of wiki API
        var urlComponents = URLComponents(string: "https://en.wikipedia.org/w/api.php?")!
        
        //add parameters to request
        urlComponents.queryItems = [
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "action", value: "query"),
            URLQueryItem(name: "prop", value: "extracts"),
            URLQueryItem(name: "exintro", value: ""),
            URLQueryItem(name: "explaintext", value: ""),
            URLQueryItem(name: "titles", value: "\(keyword)"),
        ]
        
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            //check for valid response with 200 (success)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                self.delegate?.detailsNotFound(reason: .networkRequestFailed)
                return
            }
            
            //get response
            guard let data = data, let wikiJsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] ?? [String:Any]() else {
                self.delegate?.detailsNotFound(reason: .noData)
                return
            }
            
            //parse Json
            guard let responseJsonObject = wikiJsonObject["query"] as? [String:Any], let queryJsonObject = responseJsonObject["pages"] as? [String:Any] else {
                self.delegate?.detailsNotFound(reason: .badJSONResponse)
                return
            }
            
            //get pageid
            var pageid = ""
            for pageJsonObject in queryJsonObject {
                pageid = pageJsonObject.key
            }
            
            //according to pageid and get details
            guard let pageJsonObject = queryJsonObject[pageid] as? [String:Any] else {
                self.delegate?.detailsNotFound(reason: .badJSONResponse)
                return
            }
            
            var title = ""
            var content = ""
            
            for item in pageJsonObject {
                if item.key == "title" {
                    title = item.value as? String ?? ""
                } else {
                    if item.key == "extract" {
                        content = item.value as? String ?? ""
                    }
                }
            }

        let wiki = WikipediaResult(title: title, content: content, imageName: imageName, locations: locations)
            self.delegate?.detailsFound(wikiDetails: wiki)
        }
        
        task.resume()
    }
}

