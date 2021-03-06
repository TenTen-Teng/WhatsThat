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

    var wikiResult = WikipediaResult(title: "", content: "", imageName: "", locations: [])
    let wikiAPIManager = WikipediaAPIManager()
    var imageName = ""
    var locations = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set title
        titleTextLabel.text = titleName
        
        wikiAPIManager.delegate = self
        
        //show progress bar
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        //fetch detail from Wiki API
        wikiAPIManager.fetchWikiDetailsResults(keyword: titleName, imageName: imageName, locations: locations)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //press save button
    @IBAction func likeButtonPressed(_ sender: Any) {
        //get current favorite list
        let currentFavoriteList = PersistanceManager.likeInstance.fetchFavoriteList()
        
        //check current favorite list is empty or not
        if currentFavoriteList.count != 0 {
            //current favorite list is not empty, check current item does exist or not
            if !currentFavoriteList.contains(where: {$0.title == wikiResult.title}) {
                //current item doesn't exist, save it to favorite list
                PersistanceManager.likeInstance.saveFavorite(wikiResult)
                //toast a message to user
                self.view.makeToast("saved! :)")
            } else{
                //current item already exist, don't save it again and toast a message to user
                self.view.makeToast("already saved! :)")
            }
        } else {
            //current favorite list is empty, save current item to favorite list
            PersistanceManager.likeInstance.saveFavorite(wikiResult)
            //toase a message to user
            self.view.makeToast("saved! :)")
        }
    }
    
    //press wiki button, to safarViewController
    @IBAction func wikiPagePressed(_ sender: Any) {
        let webSafari = SFSafariViewController(url: URL(string: wikiUrl)!)
        present(webSafari, animated: true, completion: nil)
    }
    
    //press tweer button, show tweet timeline
    @IBAction func tweetButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "tweetSegue", sender: titleName)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let searchTimelineViewController = segue.destination as! SearchTimelineTableViewController
        
        searchTimelineViewController.query = sender as! String
    }
    
    //press share button, share wiki detail
    @IBAction func shareButtonPressed(_ sender: Any) {
        let resultShare = details
        let textToShare = "Check out what I got from What's That app!  \(resultShare)! Check the link: \(self.wikiUrl) "
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: nil)
    }
}

//adhere to the WikiDetailsDelegate protocol
extension PhotoDetailsViewController: WikiDetailsDelegate {
    func detailsFound(wikiDetails: WikipediaResult) {
        self.details = wikiDetails.title
        
        let range = NSMakeRange(0, wikiDetails.title.count)
        
        //use regular expression to replace blank between words to underscore
        let regular = try! NSRegularExpression(pattern: " ", options:.caseInsensitive)
        let newKeyWord = regular.stringByReplacingMatches(in: wikiDetails.title, options: [], range: range, withTemplate: "_")
        
        self.wikiUrl = self.wikiUrl + newKeyWord
        self.wikiResult = wikiDetails
        
        DispatchQueue.main.async {
            //hide progress bar
            MBProgressHUD.hide(for: self.view, animated: true)
            
            //set textView
            self.contentTextView.text = wikiDetails.content
            
            //set text view scorllable
            let range = NSMakeRange(0, 0)
            self.contentTextView.scrollRangeToVisible(range)

        }
    }
    
    func detailsNotFound(reason: WikipediaAPIManager.FailureReason) {
        DispatchQueue.main.async {
            //hide progress bar
            MBProgressHUD.hide(for: self.view, animated: true)
            
            let alertController = UIAlertController(title: "Problem fetching Wikipedia results", message: reason.rawValue, preferredStyle: .alert)
            
            switch reason {
            case .networkRequestFailed:
                let retryAction = UIAlertAction(title: "Retry", style: .default, handler: { (action) in
                    MBProgressHUD.showAdded(to: self.view, animated: true)

                    self.wikiAPIManager.fetchWikiDetailsResults(keyword: self.titleName, imageName: self.imageName, locations: self.locations)
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

