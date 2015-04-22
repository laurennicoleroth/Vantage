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
    
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
    var collectionTransfer: NSObject = "";
    var holder: NSObject = "";
    var currentObject : NSArray = []
    var collectionID = ""
    var holderArray = []

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !(self.currentObject == []){
            unwrapCollection()
        }
    }
    
    func unwrapCollection(){
        var unwrappedObject : AnyObject = currentObject[0]
        var unwrappedCollectionID : AnyObject = (((unwrappedObject[0]!.objectId)!)!)
        var doubleUnwrapped : AnyObject = (unwrappedObject[0])!
        var collectionCollaborators : AnyObject = (((doubleUnwrapped["collaborators"])!)!)
        var collectionVideos : AnyObject = (((doubleUnwrapped["videos"])!)!)
        
        self.holderArray = [unwrappedObject, unwrappedCollectionID, doubleUnwrapped, collectionCollaborators, collectionVideos]
        
        println("############################")
        println(unwrappedCollectionID)
        println("%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
//        println(unwrappedObject)
        println("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
        println(collectionCollaborators)
        println("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
        println(collectionVideos)
        println("******************************")
        
        
    
    
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
        self.dismissViewControllerAnimated(true, completion: {})
        
        let videoData = NSData(contentsOfURL: tempImage)
        let videoFile = PFFile(name:"move.mov", data:videoData!)
        
        let userVideo = PFObject(className: "Videos")
        userVideo["video"] = videoFile
        
        let userCollection = PFObject(className: "Collection")
        userCollection.addObject(userVideo, forKey: "videos")
        
        let currentUser = PFUser.currentUser()
        userVideo["creator"] = currentUser
        
        
        if !(userCollection == []) {
            println("heiiiii")
//            var collectionQuery = PFQuery(className: "Collection")
//            var collectionObj = collectionQuery.getObjectWithId(self.holderArray[1] as! String)
            
            
            self.holderArray[3].addObject(currentUser!)
            println(self.holderArray[3])
            self.holderArray[4].addObject(userVideo)
            println(self.holderArray[4])
//            println(collectionObj)
            var collectionQuery = PFQuery(className: "Collection")
            var collectionObj = collectionQuery.getObjectWithId(self.holderArray[1] as! String)
            println("*******************************")
            println(collectionObj)
            println("****************************")
            collectionObj!.saveInBackground()
            
            
        } else {
            userCollection.addObject(userVideo, forKey: "videos")
            userCollection.addObject(currentUser!, forKey: "collaborators")
            
            userCollection.saveInBackgroundWithBlock {
                (success, error) -> Void in
                if success {
                    NSLog("Object create with id: (userCollection.objectId")
                    
                    println("+++++++++++++++++++++++++++++++")
                    println(userVideo)
                    
                    println("++++++++++++++++++++++++++++++++")
                } else {
                    NSLog("We have an error")
                }
            }
            
        }
        
        userVideo.saveInBackground()

        
        self.collectionTransfer = userCollection as NSObject
        redirect()
    }
    
    func redirect(){
        self.performSegueWithIdentifier("sendFriends", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let currentCollection = [self.collectionTransfer] as NSArray
        var DestViewController : FriendsListController = segue.destinationViewController as! FriendsListController
        println(currentCollection)
        DestViewController.currentCollection = currentCollection
        
    }
    
    func redirectPage(){
        tabBarController!.selectedViewController = tabBarController?.viewControllers!.first as? UIViewController
    }

}


