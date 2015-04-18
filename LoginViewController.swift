//
//  LoginViewController.swift
//  VYNC
//
//  Created by Thomas Abend on 2/2/15.
//  Copyright (c) 2015 Thomas Abend. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    let permissions = ["public_profile"]
    
    override func viewDidLoad() {
        super.viewDidLoad() // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning() // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func fbLoginClick(sender: AnyObject) {
        PFFacebookUtils.logInWithPermissions(permissions) {
                                (user, error) in
                                if user == nil { NSLog("Uh oh. The user cancelled the Facebook login.")
                                } else if user!.isNew { NSLog("User signed up and logged in through Facebook! \(user)")
                                } else { NSLog("User logged in through Facebook! \(user)")
                                }
                            }
    }
    
    //    @IBAction func fbLoginClick(sender: AnyObject) {
    //                PFFacebookUtils.logInWithPermissions(self.permissions, {
    //                    (user: PFUser!, error: NSError!) -> Void in
    //                    if user == nil { NSLog("Uh oh. The user cancelled the Facebook login.")
    //                    } else if user.isNew { NSLog("User signed up and logged in through Facebook! \(user)")
    //                    } else { NSLog("User logged in through Facebook! \(user)")
    //                    }
    //                })
    //            }
}