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
    var userArray = [];
    var cellID : NSString = "";
    var collectionsArray = [];
    var collectionObject : NSArray = []


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self;
        tableView.delegate = self;

        var video  = PFObject(className: "Videos")
        
        if let currentUser = PFUser.currentUser() {
            println(currentUser)
            var videoCollections = PFObject(className: "Collection")
//            println(videoCollections)
            
            var collectionQuery = PFQuery(className: "Collection")
            collectionQuery.whereKey("collaborators", equalTo:currentUser)
            println(collectionQuery)
            var object = collectionQuery.getFirstObject()
//            let usersVideos = (object!)["videos"]

//            let videosArray = (usersVideos!)
//            println(usersVideos)



            var query = PFQuery(className: "Videos")

            collectionsArray = collectionQuery.findObjects()!
            tableView.reloadData();
        }
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
//        var movie = (self.movieArray[indexPath.row]) as! PFObject
        var collection = (self.collectionsArray[indexPath.row]) as! PFObject
        let cell = collection.objectId as? NSString!
        self.cellID = cell!
        self.performSegueWithIdentifier("playVideo", sender: nil)
    }

    /* Table view protocol methods */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //Get current user
        //        var selectedFriend = (self.userArray[indexPath.row]) as! PFObject
//        let collaboratorsArray = ((currentCollection[0]["collaborators"])!)!
//        collaboratorsArray.addObject(selectedFriend)
        //Find collections that include currentUser in their collaborators array
        
        
        
        var videoQuery = (PFQuery(className:"Collection"))
        let collectionID = self.cellID as String!

        let oneObject = (videoQuery.getObjectWithId(collectionID!))!

        let unPack = (oneObject["videos"])!
        //loop here for all files. I think there might be more later....
        let firstVideoFile = (unPack[0]["video"]!)!
        let videoUrl = (firstVideoFile.url!)!
        let url = NSURL(string: videoUrl)

        let destination = segue.destinationViewController as! AVPlayerViewController

        destination.player = AVQueuePlayer(URL: url)

//        if(cellID != ""){
//        var query = PFQuery(className: "Videos")
//        println(self.cellID)
//        let cell = self.cellID as String!
//        let object = (query.getObjectWithId(cell!))!
//        let video = ((object as PFObject)["video"])!
//        let movie = (video.url!)!
//        let url = NSURL(string: movie)
//
////        let moviedata = onemovie.url
////        var videoURL = NSURL(string: moviedata!)!
//        let onemovie2 = self.movieArray[11]["video"] as! PFFile
////        println(onemovie2)
//        let moviedata2 = onemovie2.url
//        let destination = segue.destinationViewController as! AVPlayerViewController
////        var videoURL2 = NSURL(string: moviedata2!)!
////        let secondItem = AVPlayerItem(URL: videoURL2)
////        let firstItem = AVPlayerItem(URL: videoURL)
////        var movieList:AnyObject = [firstItem, secondItem]
////
//        destination.player = AVQueuePlayer(URL: url)
//        }

    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }

    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
        // 1
        var recordAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "REC" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // 2
            let recordMenu = UIAlertController(title: nil, message: "Add on!", preferredStyle: .ActionSheet)

            let callActionHandler = { (action:UIAlertAction!) -> Void in
                var collectionObject = (self.collectionsArray[indexPath.row]) as! NSArray
                println(collectionObject)
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
        var collection = (self.collectionsArray[indexPath.row])
        cell?.textLabel?.text = collection.objectId
        return cell!
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectionsArray.count;
    }

}

