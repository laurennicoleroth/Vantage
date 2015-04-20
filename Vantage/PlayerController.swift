//
//  ThirdViewController.swift
//  Vantage
//
//  Created by Apprentice on 4/18/15.
//  Copyright (c) 2015 Apprentice. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation
import Parse

class PlayerController : AVPlayerViewController {
    
    var videoList : [NSURL] = []
    var movieArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoGravity = AVLayerVideoGravityResizeAspectFill
        showsPlaybackControls = true
        var video  = PFObject(className: "Videos")
        var query = PFQuery(className: "Videos")
        movieArray = query.findObjects()!
        playVideos()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func playVideos() {
        
        for element in movieArray
        {
            let abc = (element["video"] as! PFFile).url;
            let url = NSURL(string:abc!)
            self.videoList.append(url!)
        }
        
        let items = self.videoList.map({video in AVPlayerItem(URL:video)})
        
        println(items)
        
        self.player = AVQueuePlayer(items: items) as AVQueuePlayer!
    }
    

}
