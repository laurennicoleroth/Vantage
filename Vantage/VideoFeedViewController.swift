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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self;
        tableView.delegate = self;

        var video  = PFObject(className: "Videos")
        
        var query = PFQuery(className: "Videos")
        movieArray = query.findObjects()!
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
            println("do we have a user??")
            redirectLogin()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func retrieveVideoFromParse(objects: [PFObject]) {
        var query = PFQuery(className: "Videos")
        
    }

    func redirectPage(){
        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("friendsList")as! FriendsListController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var query = PFQuery(className: "Videos")
        
        var movie = (self.movieArray[indexPath.row]) as! PFObject
        let cell = movie.objectId as? NSString!
        self.cellID = cell!
        self.performSegueWithIdentifier("playVideo", sender: nil)

    }
  
    /* Table view protocol methods */
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var query = PFQuery(className: "Videos")
        println(self.cellID)
        let cell = self.cellID as String!
        let object = (query.getObjectWithId(cell!))!
        let video = ((object as PFObject)["video"])!
        let movie = (video.url!)!
        let url = NSURL(string: movie)
        
//        let moviedata = onemovie.url
//        var videoURL = NSURL(string: moviedata!)!
        let onemovie2 = self.movieArray[11]["video"] as! PFFile
//        println(onemovie2)
        let moviedata2 = onemovie2.url
        let destination = segue.destinationViewController as! AVPlayerViewController
//        var videoURL2 = NSURL(string: moviedata2!)!
//        let secondItem = AVPlayerItem(URL: videoURL2)
//        let firstItem = AVPlayerItem(URL: videoURL)
//        var movieList:AnyObject = [firstItem, secondItem]
//        
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
        var movie = (self.movieArray[indexPath.row])
        cell?.textLabel?.text = movie.objectId // movie["objectId"] as! String
        return cell!;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let result = movieArray.count;
//        println("we have \(result) rows")
        return movieArray.count;
    }

}

