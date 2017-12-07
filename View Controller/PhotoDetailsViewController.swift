//
//  PhotoDetailsViewController.swift
//  Test2WhatsThat
//
//  Created by 李腾 on 11/19/17.
//  Copyright © 2017 李腾. All rights reserved.
//

import UIKit
import TwitterKit
import SafariServices
import MBProgressHUD
import Toast_Swift

class PhotoDetailsViewController: UIViewController, SFSafariViewControllerDelegate {
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    var details = ""
    var wikiUrl = "https://en.wikipedia.org/wiki/"
    var titleName = "title"
    var wikiResult = WikipediaResult(title: "", content: "", imageName: "")
    let wikiAPIManager = WikipediaAPIManager()
    var imageName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextLabel.text = titleName
        
        wikiAPIManager.delegate = self
        MBProgressHUD.showAdded(to: self.view, animated: true)
        wikiAPIManager.fetchWikiDetailsResults(keyword: titleName, imageName: imageName)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        let currentFavoriteList = PersistanceManager.likeInstance.fetchFavoriteList()
        
        if currentFavoriteList.count != 0 {
            if !currentFavoriteList.contains(where: {$0.title == wikiResult.title}) {
                PersistanceManager.likeInstance.saveFavorite(wikiResult)
                self.view.makeToast("saved! :)")
            } else{
                self.view.makeToast("already saved! :)")
            }
        } else {
            PersistanceManager.likeInstance.saveFavorite(wikiResult)
            self.view.makeToast("saved! :)")
        }
    }
    
    
    
    @IBAction func wikiPagePressed(_ sender: Any) {

        
        let webSafari = SFSafariViewController(url: URL(string: wikiUrl)!)
        
        present(webSafari, animated: true, completion: nil)
    }
    
    
    
    @IBAction func tweetButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "tweetSegue", sender: titleName)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let searchTimelineViewController = segue.destination as! SearchTimelineTableViewController
        
        searchTimelineViewController.query = sender as! String
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        let resultShare = details
        let textToShare = "Check out what I got! \(resultShare)!"
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    
}


extension PhotoDetailsViewController: WikiDetailsDelegate {
    func detailsFound(wikiDetails: WikipediaResult) {
        self.details = wikiDetails.title
        
        let range = NSMakeRange(0, wikiDetails.title.count)
        let regular = try! NSRegularExpression(pattern: " ", options:.caseInsensitive)
        //let newKeyWord = regular.replaceMatches(in: keyword as! NSMutableString, options: NSRegularExpression.MatchingOptions, range: range, withTemplate: "_")
        let newKeyWord = regular.stringByReplacingMatches(in: wikiDetails.title, options: [], range: range, withTemplate: "_")
        
        self.wikiUrl = self.wikiUrl + newKeyWord
        self.wikiResult = wikiDetails
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
            self.contentTextView.text = wikiDetails.content
        }
    }
    
    func detailsNotFound(reason: WikipediaAPIManager.FailureReason) {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
            
            let alertController = UIAlertController(title: "Problem fetching Wikipedia results", message: reason.rawValue, preferredStyle: .alert)
            
            switch reason {
            case .networkRequestFailed:
                let retryAction = UIAlertAction(title: "Retry", style: .default, handler: { (action) in
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                    self.wikiAPIManager.fetchWikiDetailsResults(keyword: self.titleName, imageName: self.imageName)
                })
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                
                alertController.addAction(retryAction)
                alertController.addAction(cancelAction)
                
            case .badJSONResponse, .noData:
                let okayAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(okayAction)
            }
            
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
}

