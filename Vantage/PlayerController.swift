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

class PlayerController: AVPlayerViewController {
    
    var videoList : [NSURL] = []
    var timer = UILabel(frame: CGRectMake(30, 30, 60, 60))
    var currentItemDuration = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoGravity = AVLayerVideoGravityResizeAspectFill
        showsPlaybackControls = false
        let color = UIColor(red: 1, green: 165/255, blue: 0, alpha: 1)
        let font = UIFont(name: "Egypt 22", size: 60)
        self.timer.font = font
        self.timer.text = ""
        self.timer.textColor = color
        self.view.addSubview(timer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func playVideos() {
        let items = self.videoList.map({video in AVPlayerItem(URL:video)})
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue,
        
        sender: AnyObject?) {
            
            let destination = segue.destinationViewController as! AVPlayerViewController
            
            let url = NSURL(string: "http://www.ebookfrenzy.com/ios_book/movie/movie.mov")
            
            destination.player = AVPlayer(URL: url)
            
    }
}

//class QueuLoopVideoPlayer : AVPlayerViewController {
//    var videoList : [NSURL] = []
//    var timer = UILabel(frame: CGRectMake(30, 30, 60, 60)
//    var curretnItemDuration = 0
//    
//    override func viewDidLoad()
//}