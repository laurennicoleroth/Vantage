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
    var collections = [];
    var collectionsArray = [];
    var queryList = [];
    var collectionObject: NSArray?
    var selectedCollaborators: NSArray?
    var collectionObjectId: NSString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self;
        tableView.delegate = self;
        
        var video  = PFObject(className: "Videos")
        var videoCollections = PFObject(className: "Collection")
        
        var query = PFQuery(className: "Videos")
        var collectionQuery = PFQuery(className: "Collection")
        queryList = query.findObjects()!
        collectionsArray = collectionQuery.findObjects()!
        tableView.reloadData();
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        checkUser()
        fetchCollectionsForUserAndReload()
    }
    
    func fetchCollectionsForUserAndReload() {
        var query = PFQuery(className: "Collection")
        query.whereKey("collaborators", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock({ (cols: [AnyObject]?, err:NSError?) -> Void in
            if let c = cols {
                self.collections = c
                self.tableView.reloadData();
            }
            if let e = err {
                NSLog("Error loading collection: %@", e)
            }
        })
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
        var collection = (self.collections[indexPath.row]) as! PFObject
        let cell = collection.objectId as? NSString!
        self.cellID = cell!
        println("*************************************************")
        println(cellID)
        self.performSegueWithIdentifier("playVideo", sender: nil)
    }
  
    /* Table view protocol methods */
    
    var videoUrlArray : [NSURL] = []

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let currentUser = PFUser.currentUser() {
            var collectionQuery = PFQuery(className: "Collection")
            collectionQuery.whereKey("collaborators", equalTo:currentUser)
            var object = collectionQuery.getFirstObject()! as PFObject
            let usersVideos = object["videos"] as! NSArray
            usersVideos[0].fetchIfNeeded()
            let videoFile = ((usersVideos[0]["video"])!)!
            let videoUrl = NSURL(string: (videoFile.url!)!)
            //videoList.append(videoUrl!)
        }
        
       // println(videoList)
        
        if ((self.cellID) != ""){
            println("did we get here")
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
//            var items = []
            let destination = segue.destinationViewController as! AVPlayerViewController
            destination.player = AVQueuePlayer(items: items) as AVQueuePlayer!
            self.cellID = ""
        }

        if !((collectionObjectId) == ""){
//            let currentObject = [self.collectionObject] as NSArray
            var NewViewController : CameraController = segue.destinationViewController as! CameraController
            println(self.collectionObject)
            NewViewController.selectedCollection = self.collectionObjectId
        }

    }

    func redirectCamera(){
        self.performSegueWithIdentifier("addVideo", sender: self)
    }
    
    func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) { }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count;
    }

    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
        // 1
        var recordAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "REC" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // 2
            let recordMenu = UIAlertController(title: nil, message: "Add on!", preferredStyle: .ActionSheet)
            
            let callActionHandler = { (action:UIAlertAction!) -> Void in
//                self.selectedCollaborators = ((((self.collections[indexPath.row])["collaborators"])!)!)
//                self.selectedVideos = ((((self.collections[indexPath.row])["videos"])!)!)
//                println(self.selectedCollaborators)
//                println(self.selectedVideos)
                self.collectionObjectId = (((self.collections[indexPath.row]).objectId)!)!
                self.redirectCamera()
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
        if indexPath.row < self.collections.count {
            var collection = (self.collections[indexPath.row])
            cell?.textLabel?.text = collection.objectId
        }
        return cell!
    }
}

