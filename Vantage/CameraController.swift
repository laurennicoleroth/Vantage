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

    
    
    override func viewDidAppear(animated: Bool) {
        

    }
    
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let tempImage = info[UIImagePickerControllerMediaURL] as! NSURL!
 
        let pathString = tempImage.relativePath
        self.dismissViewControllerAnimated(true, completion: {})
        
        let videoData = NSData(contentsOfURL: tempImage)
        let videoFile = PFFile(name:"move.mov", data:videoData!)
        println(videoFile)
        
        let userVideo = PFObject(className: "Videos")
        userVideo["video"] = videoFile
        
        userVideo.saveInBackground()
        redirectPage()
        
//        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//        let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("VideoFeedViewController") as! UIViewController
//        self.presentViewController(vc, animated: true, completion: nil)
        
//        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("VideoFeedViewController") as! VideoFeedViewController
//        self.presentViewController(vc, animated: true, completion: nil)
        
        
        
        println("HEY EVEANANDI. I GOT HERE YOU FOO")
        //        UISaveVideoAtPathToSavedPhotosAlbum(pathString, self, nil, nil)
    
    }
    
    func redirectPage(){
        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("camera")as! CameraViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
//    func transitionToRootView(){
//        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("RootNavigationController") as! UINavigationController
//        presentViewController(vc, animated: false, completion: {
//            done in
//            self.dismissPlayerLayer()
//        })
//    }
//    
//    @IBAction func dismissCamera(sender: AnyObject) {
//        if let gesture = sender as? UIScreenEdgePanGestureRecognizer {
//            if gesture.state == .Ended {
//                transitionToRootView()
//            }
//        } else {
//            transitionToRootView()
//        }
//    }
    

    
    func transition(Sender: UIButton!){
        let videoFeedViewController:VideoFeedViewController = VideoFeedViewController()
        
        self.presentViewController(videoFeedViewController, animated: true, completion: nil)
    }
}


