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

        
    @IBAction func showMeTheCamera(sender: AnyObject) {
        showCamera()
    }
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
        dismissViewControllerAnimated(true, completion: nil)
                redirectPage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        showCamera()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let tempImage = info[UIImagePickerControllerMediaURL] as! NSURL!
 
        let pathString = tempImage.relativePath
        self.dismissViewControllerAnimated(true, completion: {})
        
        //Create Video By Current User - Video Table
        let videoData = NSData(contentsOfURL: tempImage)
        let videoFile = PFFile(name:"move.mov", data:videoData!)
        let userVideo = PFObject(className: "Videos")
        userVideo["video"] = videoFile
        
        //Save to User Table
        let currentUser = PFUser.currentUser()
        println(currentUser)
        userVideo["creator"] = currentUser
        let userTable = PFObject(className: "User")
        
        //Save to Collection Table on Parse - Collection Table
        //Get collection table
        let userCollection = PFObject(className: "Collection")
        //Add uservideo object to Collection Table
        userCollection.addObject(userVideo, forKey: "videos")
        
        //Add collection object to the Collection pointer column on User "table"
        let currentUserID = (currentUser!.objectId)!
        
        userCollection.addObject(currentUser!, forKey: "collaborators")
        println(userCollection)
        
        userCollection.saveInBackgroundWithBlock {
            (success, error) -> Void in
            if success {
                NSLog("Object create with id: (userCollection.objectId)")
            } else {
                NSLog("We have an error")
            }
        }
        
        userVideo.saveInBackground()

        self.collectionTransfer = userCollection as NSObject


//        redirectFriends()
            redirect()
        
    
    }
    
    func redirect(){
        self.performSegueWithIdentifier("sendFriends", sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        println("**********************************This is the self.holder:")
//        println(self.holder)
//        println("\(object_getClassName(self.holder))");
        let currentCollection = [self.collectionTransfer] as NSArray
        var DestViewController : FriendsListController = segue.destinationViewController as! FriendsListController
//        var testString = "HEHE!"
//        DestViewController.collectionObject = self.holder
        DestViewController.currentCollection = currentCollection
        
        
        
    }
    
   
    
//    func redirectFriends(){
//        println("*************THIS IS THE SELF.COLLECTIONTRANSFER:************")
//        println(self.collectionTransfer)
//        
//        self.performSegueWithIdentifier("transfer", sender: self)
////
////        
////        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("friendsList")as! FriendsListController
////        self.presentViewController(vc, animated: true, completion: nil)
//    }
    
    
    
    func redirectPage(){
        tabBarController!.selectedViewController = tabBarController?.viewControllers!.first as? UIViewController
        navigationController?.popToRootViewControllerAnimated(true)
    }

}


