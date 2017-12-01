//
//  FavoritePhotosTableViewController.swift
//  WhatsThat
//
//  Created by 李腾 on 11/20/17.
//  Copyright © 2017 李腾. All rights reserved.
//
import UIKit


class FavoritePhotosTableViewController: UITableViewController {
    
    var favoriteList = PersistanceManager.likeInstance.fetchFavoriteList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoritePhotoTableViewCell
        
        let favoriteItem = favoriteList[indexPath.row]
        
        cell.photoIdenText.text = favoriteItem.title
        //cell.imageView.image = favoriteItem.image
        return cell
    }
    
}

