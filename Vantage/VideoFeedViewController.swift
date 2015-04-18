//
//  FirstViewController.swift
//  Vantage
//
//  Created by Apprentice on 4/18/15.
//  Copyright (c) 2015 Apprentice. All rights reserved.
//

import UIKit
import Parse

class VideoFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!
    var movieArray = [];

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self;
        tableView.delegate = self;
        
//        let testObject = PFObject(className: "TestObject")
//        testObject["foo"] = "baringo"
//        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//            println("Object has been saved.")
//        }
        // Do any additional setup after loading the view, typically from a nib.
        var video  = PFObject(className: "Videos")
        println(video)
        var query = PFQuery(className: "Videos")
        println(query)
        movieArray = query.findObjects()!
        tableView.reloadData();
        println(movieArray);
//        query.getObjectInBackgroundWithId(video.objectId) {
//            (scoreAgain: PFObject!, error: NSError!) -> Void in
//            if !error {
//                println("error")
//            } else {
//                println("success")
//            }
//        var video = query.getObjectInBackgroundWithId("MQfB6Lc3lh")
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func retrieveVideoFromParse(objects: [PFObject]) {
        var query = PFQuery(className: "Videos")
        
        
     
//        for object in objects {
//            println("found an object")
//        }
//        println("hi")
//        let userVideo = PFObject(className: "Videos")
//        let userVideoFile = userVideo["video"] as! PFFile
//        
//        println(userVideoFile)
    }
  
    /* Table view protocol methods */
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "cell"
        var cell:UITableViewCell? = self.tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as? UITableViewCell
        if(cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        }
        var movie = (self.movieArray[indexPath.row]) as! PFObject
        println(movie.objectId)
        println(movie)
        cell?.textLabel?.text = movie.objectId // movie["objectId"] as! String
        return cell!;
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let result = movieArray.count;
        println("we have \(result) rows")
        return movieArray.count;
    }

}

