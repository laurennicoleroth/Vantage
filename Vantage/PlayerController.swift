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

class PlayerController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue,
        
        sender: AnyObject?) {
            
            let destination = segue.destinationViewController as! AVPlayerViewController
            
            let url = NSURL(string: "http://www.ebookfrenzy.com/ios_book/movie/movie.mov")
            
            destination.player = AVPlayer(URL: url)
            
    }
}
