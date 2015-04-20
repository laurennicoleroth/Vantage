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

class VideoFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!
    var movieArray = [];

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self;
        tableView.delegate = self;

        var video  = PFObject(className: "Videos")
        
        var query = PFQuery(className: "Videos")
        movieArray = query.findObjects()!
        tableView.reloadData();
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func retrieveVideoFromParse(objects: [PFObject]) {
        var query = PFQuery(className: "Videos")
        
    }
  
    /* Table view protocol methods */
    
    func redirectPage(){
        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("friendsList")as! FriendsListController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let onemovie = self.movieArray[0]["video"] as! PFFile
 
        let moviedata = onemovie.url
        
        var videoURL = NSURL(string: moviedata!)!
        
        let onemovie2 = self.movieArray[11]["video"] as! PFFile
        let moviedata2 = onemovie2.url
        
        var videoURL2 = NSURL(string: moviedata2!)!
        
        let destination = segue.destinationViewController as! AVPlayerViewController
        
        let secondItem = AVPlayerItem(URL: videoURL2)
        let firstItem = AVPlayerItem(URL: videoURL)
        
        var movieList:AnyObject = [firstItem, secondItem]
        
        destination.player = AVQueuePlayer(items: movieList as! [AnyObject])
        
        //        queuePlayer = [AVQueuePlayer queuePlayerWithItems:[NSArray arrayWithObjects:firstVideoItem, secondVideoItem,nil]];
        
        //        var firstItem = AVPlayerItem(playerItemWithURL: videoURL)
        //        var secondItem = AVPlayerItem(playerItemWithURL: videoURL2)
        //
        ////        AVPlayerItem *firstItem = [AVPlayerItem, playerItemWithURL: firstItemURL];
        ////        AVPlayerItem *secondItem = [AVPlayerItem playerItemWithURL: secondItemURL];
        //
        //        AVQueuePlayer *player = [AVQueuePlayer queuePlayerWithItems:[NSArray arrayWithObjects:firstItem, secondItem, nil]];
        
        
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
            
            let recordAction = UIAlertAction(title: "Record", style: UIAlertActionStyle.Default, handler: callActionHandler)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            
            
            recordMenu.addAction(recordAction)
            recordMenu.addAction(cancelAction)
            
            
            self.presentViewController(recordMenu, animated: true, completion: nil)
        })
        // 3
        var playAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: ">" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // 4
            let playMenu = UIAlertController(title: nil, message: "Play!", preferredStyle: .ActionSheet)
            
            let playAction = UIAlertAction(title: "Play", style: UIAlertActionStyle.Default, handler: nil)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            
            playMenu.addAction(playAction)
            playMenu.addAction(cancelAction)
            
            
            self.presentViewController(playMenu, animated: true, completion: nil)
        })
        // 5
        return [recordAction,playAction]
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "cell"
        var cell:UITableViewCell? = self.tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as? UITableViewCell
        if(cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        }
        var movie = (self.movieArray[indexPath.row]) as! PFObject
        cell?.textLabel?.text = movie.objectId // movie["objectId"] as! String
        return cell!;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let result = movieArray.count;
        println("we have \(result) rows")
        return movieArray.count;
    }

}

