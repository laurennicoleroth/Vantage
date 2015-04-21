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
    var collectionsArray = [];
    var cellID : NSString = "";
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self;
        tableView.delegate = self;

        var video  = PFObject(className: "Videos")
        var videoCollections = PFObject(className: "Collection")
        
        var query = PFQuery(className: "Videos")
        var collectionQuery = PFQuery(className: "Collection")
        
        movieArray = query.findObjects()!
        collectionsArray = collectionQuery.findObjects()!
        
        tableView.reloadData();
        
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
            redirectLogin()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func redirectPage(){
        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("friendsList")as! FriendsListController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        var query = PFQuery(className: "Videos")
        
        var movie = (self.movieArray[indexPath.row]) as! PFObject
        var collection = (self.collectionsArray[indexPath.row]) as! PFObject
        println("#####################################")
        println(collection.objectId)
        let cell = collection.objectId as? NSString!
        self.cellID = cell!
        self.performSegueWithIdentifier("playVideo", sender: nil)

    }
  
    /* Table view protocol methods */
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
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
        
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
        // 1
        var recordAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "REC" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // 2
            let recordMenu = UIAlertController(title: nil, message: "Add on!", preferredStyle: .ActionSheet)
            
            let callActionHandler = { (action:UIAlertAction!) -> Void in
                var vc = self.storyboard?.instantiateViewControllerWithIdentifier("friendsList")as! FriendsListController
                self.presentViewController(vc, animated: true, completion: nil)
                
            }
            
            let callActionHandlerr = { (action:UIAlertAction!) -> Void in
                let alertMessage = UIAlertController(title: "Service Unavailable", message: "Sorry, the call feature is not available yet. Please retry later.", preferredStyle: .Alert)
                alertMessage.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alertMessage, animated: true, completion: nil)
            }
            
            let selectedIndexPath = tableView.indexPathForSelectedRow()
            
            let recordAction = UIAlertAction(title: "Record", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in println(selectedIndexPath)})
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            
            
            recordMenu.addAction(recordAction)
            recordMenu.addAction(cancelAction)
            
            
            self.presentViewController(recordMenu, animated: true, completion: nil)
        })
        // 3

        // 5
        return [recordAction]
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "cell"
        var cell:UITableViewCell? = self.tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as? UITableViewCell
        if(cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        }
        var collection = (self.collectionsArray[indexPath.row])
        cell?.textLabel?.text = collection.objectId
        return cell!;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let result = movieArray.count;
//        println("we have \(result) rows")
        return movieArray.count;
    }

}

