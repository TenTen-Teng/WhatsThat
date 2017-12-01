//
//  PhotoIdenViewController.swift
//  WhatsThat
//
//  Created by 李腾 on 11/16/17.
//  Copyright © 2017 李腾. All rights reserved.
//

import UIKit
import MBProgressHUD

class PhotoIdenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    

    @IBOutlet weak var imageView: UIImageView!
    
    var results = [GoogleVisionResult]()
    let googleVisionAPIManager = GoogleVisionAPIManager()
    var pickedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chooseImage()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func chooseImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
            (action: UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                //need to handle camera not available situation
                print("Camera not available")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {
            (action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imageView.image = image
        pickedImage = image
        MBProgressHUD.showAdded(to: self.view, animated: true)
        googleVisionAPIManager.delegate = self
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
    }
    
}

extension PhotoIdenViewController: IdentificationDelegate {
    func resultsFound(googleVisionResults: [GoogleVisionResult]) {
        self.results = googleVisionResults
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
            self.tableView.reloadData()
        }
    }
    
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


