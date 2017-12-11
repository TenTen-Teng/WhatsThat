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
        
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent(favoriteItem.imageName + ".jpg")
        if fileManager.fileExists(atPath: imagePAth){
            cell.favrImage.image = UIImage(contentsOfFile: imagePAth)!
        }else{
            print("No Image")
        }
        
        cell.photoIdenText.text = favoriteItem.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "favorDetailsSegue", sender: favoriteList[indexPath.row].title)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            PersistanceManager.likeInstance.unfavorite(indexPath.row)
            favoriteList.remove(at: indexPath.row)

            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "mapSegue") {
            let mapViewController = segue.destination as! MapViewController
            
        } else if (segue.identifier == "favorDetailsSegue") {
            let photoDetailsViewController = segue.destination as! PhotoDetailsViewController
            
            photoDetailsViewController.titleName = sender as! String
        }
    }
    
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}

