//
//  PersistanceManager.swift
//  WhatsThat
//
//  Created by 李腾 on 11/12/17.
//  Copyright © 2017 李腾. All rights reserved.
//
import Foundation

protocol FavoriteIdenDelegate {
    func listFound(favs: [WikipediaResult])
    func listNotFound()
}

class PersistanceManager {
    var delegate: FavoriteIdenDelegate?
    
    static let likeInstance = PersistanceManager()
    let favoriteKey = "favorite"
    
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
    
    func saveFavorite(_ favorite: WikipediaResult) {
        let userDefaults = UserDefaults.standard
        
        var newFavoriteList = fetchFavoriteList()
        newFavoriteList.append(favorite)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: newFavoriteList)
        
        userDefaults.set(data, forKey: favoriteKey)
    }
    
}

