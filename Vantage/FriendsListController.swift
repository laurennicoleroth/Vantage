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
        if let col = collection {
            col.addObject(selectedFriend, forKey: "collaborators")
        }
    }
    
    /* Table view protocol methods */
    
    func redirectPage(){
        //        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("friendsList")as! FriendsListController
        //        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
        // 1
        var recordAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "REC" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // 2
            let recordMenu = UIAlertController(title: nil, message: "Add on!", preferredStyle: .ActionSheet)
            
            let callActionHandler = { (action:UIAlertAction!) -> Void in
                //                var vc = self.storyboard?.instantiateViewControllerWithIdentifier("friendsList") as! FriendsListController
                //                self.presentViewController(vc, animated: true, completion: nil)
                
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