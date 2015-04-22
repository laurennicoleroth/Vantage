//
//  SecondViewController.swift
//  Vantage
//
//  Created by Apprentice on 4/18/15.
//  Copyright (c) 2015 Apprentice. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices
import AVFoundation
import Parse

class CameraController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    var collection: PFObject?
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
    var selectedObject: PFObject?
    var selectedCollection: NSString = ""

    func showCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            println("captureVideoPressed and camera available.")
            
            var imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera;
            imagePicker.mediaTypes = [kUTTypeMovie!]
            imagePicker.allowsEditing = false
            imagePicker.showsCameraControls = true
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
            navigationController?.popToRootViewControllerAnimated(true)
        }
            
        else {
            println("Camera not available.")
        }
        
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        if (tabBarController == nil){
            println("uhoh! yay!")
            self.performSegueWithIdentifier("goHome", sender: self)
        } else {
        dismissViewControllerAnimated(true, completion: nil)
                redirectPage()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        showCamera()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let tempImage = info[UIImagePickerControllerMediaURL] as! NSURL!
        let pathString = tempImage.relativePath
        
        // TODO: check if we need this
        self.dismissViewControllerAnimated(true, completion: {})
        
        let videoData = NSData(contentsOfURL: tempImage)
        println("***************ANGELWANTSTHISHERE*********************")
        let videoFile = PFFile(name:"move.mov", data:videoData!)
        println(videoFile)
        
        let video = PFObject(className: "Videos")
        println(video)
        video["video"] = videoFile
        video["creator"] = PFUser.currentUser()!
        
        let currentUser = video["creator"]
        video.saveInBackground()

        /*
        self.holderArray = [unwrappedObject, unwrappedCollectionID, doubleUnwrapped, collectionCollaborators, collectionVideos]
        */
        
        // TODO: I feel like this could be Swiftier.
        var col = (collection != nil) ? collection! : PFObject(className: "Collection")
        
        if !(self.selectedCollection == "") {
            let query = PFQuery(className: "Collection")
            let selectCollection = (query.getObjectWithId(self.selectedCollection as String))!
            println(selectCollection)
            var collaborators = (selectCollection["collaborators"])!
            var videos = (selectCollection["videos"])!
            selectCollection.addObject(currentUser!, forKey: "collaborators")
            selectCollection.addObject(video, forKey: "videos")
            println(selectCollection)
            self.collection = selectCollection
            selectCollection.saveInBackground()
            

        } else {
            col.addObject(PFUser.currentUser()!, forKey: "collaborators")
                    col.addObject(video, forKey: "videos")
                    col.saveInBackgroundWithBlock {
                        (success, error) -> Void in
                        if let err = error {
                            NSLog("Error saving collection: %@", err)
                        }
                    }
            self.collection = col

        }
        self.selectedCollection = ""
        redirect()
    }
    
    func redirect(){
        self.performSegueWithIdentifier("sendFriends", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var friendsList : FriendsListController = segue.destinationViewController as! FriendsListController
        friendsList.collection = self.collection
    }
    
    func redirectPage(){
        tabBarController!.selectedViewController = tabBarController?.viewControllers!.first as? UIViewController
    }

}


