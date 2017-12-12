//
//  PersistanceManager.swift
//  WhatsThat
//
//  Created by 李腾 on 11/12/17.
//  Copyright © 2017 李腾. All rights reserved.
//
import Foundation

//protocol for FavoriteIdenDelegate results, return a list of WikipediaResult or not found
protocol FavoriteIdenDelegate {
    func listFound(favs: [WikipediaResult])
    func listNotFound()
}

class PersistanceManager {
    var delegate: FavoriteIdenDelegate?
    
    static let likeInstance = PersistanceManager()
    let favoriteKey = "favorite"
    
    //fetch favorite list from Persistance
    func fetchFavoriteList() -> [WikipediaResult] {
        let userDefaults = UserDefaults.standard
        
        let data = userDefaults.object(forKey: favoriteKey) as? Data
        
        if let data = data {
            //data is not nil, so use it
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? [WikipediaResult] ?? [WikipediaResult]()
        }
        else {
            //data is nil
            return [WikipediaResult]()
        }
    }
    
    //save a favorite to Persistance
    func saveFavorite(_ favorite: WikipediaResult) {
        let userDefaults = UserDefaults.standard
        
        var newFavoriteList = fetchFavoriteList()
        newFavoriteList.append(favorite)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: newFavoriteList)
        
        userDefaults.set(data, forKey: favoriteKey)
    }
    
    //unfavorite a item, delete it from Persistance
    func unfavorite(_ unfavorite: Int) {
        let userDefaults = UserDefaults.standard
        
        var newFavoriteList = fetchFavoriteList()
        newFavoriteList.remove(at: unfavorite)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: newFavoriteList)
        
        userDefaults.set(data, forKey: favoriteKey)
    }
    
}

