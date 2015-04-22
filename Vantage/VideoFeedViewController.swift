//
//  FirstViewController.swift
//  Vantage
//
//  Created by Apprentice on 4/18/15.
//  Copyright (c) 2015 Apprentice. All rights reserved.
//

import UIKit
import Parse
import AVFoundation
import AVKit
import ParseUI

class VideoFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var movieArray = [];
    var cellID : NSString = "";
    var collectionsArray = [];
    var collectionObject : NSArray = []
    var videoIdList : NSMutableArray = []
    var videoList : [NSURL] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self;
        tableView.delegate = self;
        
        //FFA44B nav/background 
        //FFECDB cells
        
        view.backgroundColor = UIColorFromRGB(0xFFA44B)
        
        var video  = PFObject(className: "Videos")
        var videoCollections = PFObject(className: "Collection")
        
        var query = PFQuery(className: "Videos")
        var collectionQuery = PFQuery(className: "Collection")
        
        movieArray = query.findObjects()!
        collectionsArray = collectionQuery.findObjects()!
        tableView.reloadData();
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(animated)
        checkUser()
    }
    
    func redirectLogin(){
        self.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.modalPresentationStyle = .CurrentContext
        self.presentViewController(LoginVC(), animated:true, completion:nil)
    }
    
    func checkUser() {
        
        var currentUser = PFUser.currentUser()
        if (currentUser == nil){
            println("do we have a user??")
            redirectLogin()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func retrieveVideoFromParse(objects: [PFObject]) {
        var query = PFQuery(className: "Videos")
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var movie = (self.movieArray[indexPath.row]) as! PFObject
        var collection = (self.collectionsArray[indexPath.row]) as! PFObject
        let cell = collection.objectId as? NSString!
        self.cellID = cell!
        self.performSegueWithIdentifier("playVideo", sender: nil)
    }
  
    /* Table view protocol methods */
    
    var videoUrlArray : [NSURL] = []

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if !(self.cellID == ""){
            var videoList : [NSURL] = []
            let videoQuery = (PFQuery(className:"Collection"))
            let collectionID = self.cellID as String!
            let oneObject = (videoQuery.getObjectWithId(collectionID!))!
            let unPack = (oneObject["videos"])!
            let firstVideoFile: NSArray = [unPack[0]]
            let urlArray:AnyObject = []
            for index in 0..<unPack.count{
                let videoObjectId = (((unPack[index].objectId!)!))
                let arrayQuery = PFQuery(className: "Videos")
                let arrayObject = arrayQuery.getObjectWithId(videoObjectId)
                let videoPffile = (((arrayObject!)["video"])!)
                let videoUrl = NSURL(string: (videoPffile.url!)!)
                videoList.append(videoUrl!)
            }
        
            let items = videoList.map({video in AVPlayerItem(URL: video)})
            let destination = segue.destinationViewController as! AVPlayerViewController
            destination.player = AVQueuePlayer(items: items) as AVQueuePlayer!
        }

        if !(self.collectionObject == []){
            println("does this even happen??")
            let currentObject = [self.collectionObject] as NSArray
            var NewViewController : CameraController = segue.destinationViewController as! CameraController
            println(currentObject)
            NewViewController.currentObject = currentObject
    
        }

        
    }

    func redirectCamera(){
        self.performSegueWithIdentifier("addVideo", sender: self)
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
        // 1
        var recordAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "REC" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // 2
            let recordMenu = UIAlertController(title: nil, message: "Add on!", preferredStyle: .ActionSheet)
            
            let callActionHandler = { (action:UIAlertAction!) -> Void in
                var collectionRow : NSArray = [self.collectionsArray[indexPath.row]]
                self.collectionObject = (collectionRow)
                self.redirectCamera()
            }
            
            let callActionHandlerr = { (action:UIAlertAction!) -> Void in
                let alertMessage = UIAlertController(title: "Service Unavailable", message: "Sorry, the call feature is not available yet. Please retry later.", preferredStyle: .Alert)
                alertMessage.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alertMessage, animated: true, completion: nil)
            }
            
            let selectedIndexPath = tableView.indexPathForSelectedRow()
            
            let recordAction = UIAlertAction(title: "Record", style: UIAlertActionStyle.Default, handler: callActionHandler)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            
            
            recordMenu.addAction(recordAction)
            recordMenu.addAction(cancelAction)
            
            
            self.presentViewController(recordMenu, animated: true, completion: nil)
        })
        // 3

        // 5
        return [recordAction]
    }
    
    func newRecording(){
        self.performSegueWithIdentifier("addVideo", sender: self)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "cell"
        var cell:UITableViewCell? = self.tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as? UITableViewCell
        if(cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        }
        if indexPath.row < self.collectionsArray.count {
            var collection = (self.collectionsArray[indexPath.row])
            var image : UIImage? = UIImage( named: "brows.pdf")
            cell?.imageView?.image = image
            cell?.textLabel?.text = collection.objectId
            cell?.backgroundColor = UIColorFromRGB(0xFFE5B7);
            let gradient = CAGradientLayer()
            cell?.backgroundView = UIView()
            cell?.backgroundView?.layer.insertSublayer(gradient, atIndex: 0)
            
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieArray.count;
    }

}

