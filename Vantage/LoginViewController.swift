//
//  LoginViewController.swift
//  Vantage
//
//  Created by Angel Baek on 4/18/15.
//  Copyright (c) 2015 Apprentice. All rights reserved.
//

import Foundation
import Parse
import UIKit

class LoginViewController: UIViewController{
    
    let service = "swiftLogin"
    let userAccount = "swiftLoginUser"
    let key = "RandomKey"
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    
    @IBAction func loginTapped(sender: UIButton) {
        activityIndicator.hidden = true
        
        var username = txtUsername.text
        var password = txtPassword.text
        
        
        if ((count(username.utf16)) < 4 || (count(password.utf16)) < 5){
            var alert = UIAlertView(title: "Invalid", message: "Username must be greater then 4 and Password must be greater then 5", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        } else { PFUser.logInWithUsernameInBackground(username, password: password, block: {(user, error) -> Void in
            self.activityIndicator.hidden = false
            self.activityIndicator.startAnimating()
            
            if (user != nil){
                var alert = UIAlertView(title: "Success", message: "Logged In", delegate: self, cancelButtonTitle: "OK")
                println(user!.username)
                println(user!.password)
                alert.show()
//                PFUser.becomeInBackground

                } else {
                    self.activityIndicator.stopAnimating()
                    var alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                    println(user!.username)
                    println(user!.password)
                    alert.show()
                
            }
        })}
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidden = true
    }

    
    override func viewDidLoad(){
        super.viewDidLoad()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
        
    }
    
    

    @IBAction func signUpTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("goto_signup", sender: self)
    }
    
    
    
};