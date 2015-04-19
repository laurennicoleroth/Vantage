//
//  FirstViewController.swift
//  Vantage
//
//  Created by Apprentice on 4/18/15.
//  Copyright (c) 2015 Apprentice. All rights reserved.
//

import UIKit
import Parse
import AVKit
import AVFoundation

class VideoFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!
    var movieArray = [];

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self;
        tableView.delegate = self;


        var video  = PFObject(className: "Videos")
        println(video)
        var query = PFQuery(className: "Videos")
        println(query)
        movieArray = query.findObjects()!
        tableView.reloadData();
        println(movieArray);
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func retrieveVideoFromParse(objects: [PFObject]) {
        var query = PFQuery(className: "Videos")
        
        
    }
  
    /* Table view protocol methods */

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "cell"
        var cell:UITableViewCell? = self.tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as? UITableViewCell
        if(cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        }
        var movie = (self.movieArray[indexPath.row]) as! PFObject
//        println(movie.objectId)
//        println(movie)
        let videoFile = movie.objectForKey("video") as! PFFile
        println(videoFile)
//        userImageFile.getDataInBackgroundWithBlock {
//            (imageData: NSData!, error: NSError!) -> Void in
//            if !error {
//                let image = UIImage(data:imageData)
//            }
//        }
        cell?.textLabel?.text = movie.objectId // movie["objectId"] as! String
        return cell!;
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let result = movieArray.count;
        println("we have \(result) rows")
        return movieArray.count;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue,
        
        sender: AnyObject?) {
          
            let destination = segue.destinationViewController as! AVPlayerViewController
            let url = NSURL(string: "http://www.ebookfrenzy.com/ios_book/movie/movie.mov")
            destination.player = AVPlayer(URL: url)
            
    }

}

