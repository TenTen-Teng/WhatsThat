//
//  FavoritePhotosTableViewController.swift
//  WhatsThat
//
//  Created by 李腾 on 11/20/17.
//  Copyright © 2017 李腾. All rights reserved.
//
import UIKit

class FavoritePhotosTableViewController: UITableViewController {
    //get favorite list from Persistance
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
        
        //set image path
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent(favoriteItem.imageName + ".jpg")
        
        //if image exist, show image
        if fileManager.fileExists(atPath: imagePAth){
            //set image
            cell.favrImage.image = UIImage(contentsOfFile: imagePAth)!
        }else{
            print("No Image")
        }
        
        //set cell row text
        cell.photoIdenText.text = favoriteItem.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "favorDetailsSegue", sender: favoriteList[indexPath.row].title)
    }
    
    //remove item from table
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            PersistanceManager.likeInstance.unfavorite(indexPath.row)
            favoriteList.remove(at: indexPath.row)

            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

    @IBAction func mapView(_ sender: Any) {
        performSegue(withIdentifier: "mapSegue", sender: self.favoriteList)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //press map button, turn to map page
        if segue.identifier == "mapSegue" {
            let mapViewController = segue.destination as! MapViewController
            mapViewController.wikiResults = sender as! [WikipediaResult]

        }
        
        //press row, turn to detail page
        if segue.identifier == "favorDetailsSegue" {
            let photoDetailsViewController = segue.destination as! PhotoDetailsViewController
            photoDetailsViewController.titleName = sender as! String
        }
    }
    
    //get directory path
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}

