////
////  FriendsListController.swift
////

import UIKit
import Parse
import AVFoundation
import AVKit

class FriendsListController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var userArray = [];
    var collection: PFObject?
    var holderArray : NSArray = []
    
    @IBOutlet weak var tableView: UITableView!
   
    @IBAction func backHome(sender: AnyObject) {
        // redirects you home. maintains tabs
        println("why arent we going back????")
        //navigationController!.showViewController(VideoFeedViewController(), sender: self)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self;
        tableView.delegate = self;

        if let users = PFUser.query() {
            userArray = users.findObjects()!
            println(userArray)
            tableView.reloadData();
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func retrieveVideoFromParse(objects: [PFObject]) {
        var query = PFQuery(className: "User")
        println(query)
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedFriend = (self.userArray[indexPath.row]) as! PFObject
        if let col = self.collection {
            col.addObject(selectedFriend, forKey: "collaborators")
            col.saveInBackground()
        }
        self.collection = nil
        dismissViewControllerAnimated(true, completion: nil)
//        performSegueWithIdentifier("toVideoFeed", sender: self)
    }
    
    /* Table view protocol methods */
    
    func redirectPage(){
        //        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("friendsList")as! FriendsListController
        //        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "cell"
        var cell:UITableViewCell? = self.tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as? UITableViewCell
        if(cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        }
        var user = (self.userArray[indexPath.row]) as! PFObject
        cell?.textLabel?.text = (user["username"] as! String)
        return cell!;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let result = userArray.count;
        println("we have \(result) rows")
        return result;
    }
    
}