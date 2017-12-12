//
//  PhotoIdenViewController.swift
//  WhatsThat
//
//  Created by 李腾 on 11/16/17.
//  Copyright © 2017 李腾. All rights reserved.
//

import UIKit
import MBProgressHUD
import Toast_Swift

class PhotoIdenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var results = [GoogleVisionResult]()
    let googleVisionAPIManager = GoogleVisionAPIManager()
    var pickedImage: UIImage!
    var imageName = ""
    let persistanceManager = PersistanceManager()
    let locationFinder = LocationFinder()
    var locations = [Double]()
    var imagePath = NSURL()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationFinder.delegate = self
        locationFinder.findLocation()
        googleVisionAPIManager.delegate = self

        //choose image from camera or photo library
        chooseImage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //pop up a action sheet and choose image
    private func chooseImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        //set action sheet
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        //choose image from camera
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
            (action: UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                //pick image from camera
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                //Camera not available, toast a message to user
                self.view.makeToast("Camera not available :( ... ")
            }
        }))
        
        //choose image from photo library
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {
            (action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        //cancel
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //get image
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //show it to image view
        imageView.image = image
        
        pickedImage = image
        
        //count current number of image in favorite list and set number as current image name
        imageName = String(persistanceManager.fetchFavoriteList().count)
        
        //save current image to document directory
        saveImageDocumentDirectory(image: pickedImage, name: String(imageName))
        
        //show progress bar
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        //fetch google vision results from googleVision API by passing image
        googleVisionAPIManager.fetchGoogleVisionResults(image: image)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! PhotoIdentificationTableViewCell
        
        //set table row
        cell.descriptionLabel?.text = results[indexPath.row].description
        cell.scoreLabel?.text =  results[indexPath.row].score
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "photoDetailsSegue", sender: results[indexPath.row].description)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let photoDetailsViewController = segue.destination as! PhotoDetailsViewController
        
        photoDetailsViewController.titleName = sender as! String
        photoDetailsViewController.imageName = imageName
        photoDetailsViewController.locations = locations
    }
    
    //get image directory path
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    //save image to document directory
    func saveImageDocumentDirectory(image: UIImage, name: String){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(name + ".jpg")
        let image = image
        
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }
    
    //if directory path doesn't exist, create a dirextory
    func createDirectory(){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("WhatsThatDirectory")
        if !fileManager.fileExists(atPath: paths){
            try! fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
        }else{
            print("Already dictionary created.")
        }
    }
    
}

//adhere to the IdentificationDelegate protocol
extension PhotoIdenViewController: IdentificationDelegate {
    //get google vision result, return results
    func resultsFound(googleVisionResults: [GoogleVisionResult]) {
        self.results = googleVisionResults
        DispatchQueue.main.async {
            //hide progress bar
            MBProgressHUD.hide(for: self.view, animated: true)
            self.tableView.reloadData()
        }
    }
    
    //return failure reasons
    func resultsNotFound(reason: GoogleVisionAPIManager.FailureReason) {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
            
            let alertController = UIAlertController(title: "Problem fetching Google Vision results", message: reason.rawValue, preferredStyle: .alert)
            
            switch reason {
            case .networkRequestFailed:
                let retryAction = UIAlertAction(title: "Retry", style: .default, handler: { (action) in
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                    self.googleVisionAPIManager.fetchGoogleVisionResults(image: self.pickedImage!)
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

//adhere to the LocationFinderDelegate protocol
extension PhotoIdenViewController: LocationFinderDelegate {
    func locationFound(latitude: Double, longitude: Double) {
        locations.append(latitude)
        locations.append(longitude)
    }
    
    func locationNotFound(reason: LocationFinder.FailureReason) {
        self.view.makeToast("Can not get location! :( ...")
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
            //TODO pop up an alert controller with message
            print(reason.rawValue)
        }
    }
}


