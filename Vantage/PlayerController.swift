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

class PlayerController: AVPlayerViewController {
    
    var movieArray = []
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
        var movieArray = []
        var video  = PFObject(className: "Videos")
        var query = PFQuery(className: "Videos")
        movieArray = query.findObjects()!
        let result = movieArray.count;
        println(result);
        
        let onemovie = self.movieArray[0]["video"] as! PFFile
        println(onemovie)
        
//        let moviedata = onemovie.url
//        
//        var videoURL = NSURL(string: moviedata!)!
//        
//        let destination = segue.destinationViewController as! AVPlayerViewController
//        
//        destination.player = AVPlayer(URL: videoURL)
        
//        let items = self.movieArray.map({video in AVPlayerItem(URL:video)})
//        self.player = AVQueuePlayer(items: items) as AVQueuePlayer!
//        
//        let duration = Int(round(CMTimeGetSeconds(items.first!.asset.duration)))
//        self.currentItemDuration = duration
//        self.player.addPeriodicTimeObserverForInterval(
//            CMTimeMake(1,1),
//            queue: dispatch_get_main_queue(),
//            usingBlock: {
//                (callbackTime: CMTime) -> Void in
//                let t1 = CMTimeGetSeconds(callbackTime)
//                let t2 = Int(CMTimeGetSeconds(self.player!.currentTime()))
//                self.timer.text = "\(self.currentItemDuration - t2)"
//        })
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "repeat:", name: "AVPlayerItemDidPlayToEndTimeNotification", object: nil)
//        self.player.play()
    }
    
    func continuePlay() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "repeat:", name: "AVPlayerItemDidPlayToEndTimeNotification", object: nil)
        self.player.play()
    }
    
    func stop(){
        self.player.pause()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "AVPlayerItemDidPlayToEndTimeNotification", object: nil)
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func repeat(notification:NSNotification){
        if var playerItem = notification.object as? AVPlayerItem {
            var asset = playerItem.asset
            var copyOfPlayerItem = AVPlayerItem(asset: asset)
            var player = self.player as! AVQueuePlayer
            player.insertItem(copyOfPlayerItem, afterItem: nil)
            // Get the duration of the upcoming video to display countdown
            if let second = player.items()[1] as? AVPlayerItem {
                var duration = Int(round(CMTimeGetSeconds(second.asset.duration)))
                self.currentItemDuration = duration
            }
            println("REPEAT. Items Size=\(player.items().count)")
        }
    }

    
//    override func prepareForSegue(segue: UIStoryboardSegue,
//        
//        sender: AnyObject?) {
//            
//            let destination = segue.destinationViewController as! AVPlayerViewController
//            
//            let url = NSURL(string: "http://www.ebookfrenzy.com/ios_book/movie/movie.mov")
//            
//            destination.player = AVPlayer(URL: url)
//            
//    }
}

//class QueuLoopVideoPlayer : AVPlayerViewController {
//    var videoList : [NSURL] = []
//    var timer = UILabel(frame: CGRectMake(30, 30, 60, 60)
//    var curretnItemDuration = 0
//    
//    override func viewDidLoad()
//}