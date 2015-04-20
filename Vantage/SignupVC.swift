//
//  SignupVC.swift
//  Vantage
//
//  Created by Angel Baek on 4/18/15.
//  Copyright (c) 2015 Apprentice. All rights reserved.
//

import Foundation
import UIKit
import Parse

class SignupVC: UIViewController{
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidden = true
        activityIndicator.hidesWhenStopped = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signupTapped(sender: AnyObject) {
        // Build the terms and conditions alert
        let alertController = UIAlertController(title: "Agree to terms and conditions",
            message: "Click I AGREE to signal that you agree to the End User Licence Agreement.",
            preferredStyle: UIAlertControllerStyle.Alert
        )
        
        alertController.addAction(UIAlertAction(title: "I AGREE",
            style: UIAlertActionStyle.Default,
            handler: { alertController in self.processSignUp()})
        )
        
        alertController.addAction(UIAlertAction(title: "I do NOT agree",
            style: UIAlertActionStyle.Default,
            handler: nil)
        )
        
        // Display alert
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func processSignUp(){
    
        var username:NSString = txtUsername.text as NSString
        var password:NSString = txtPassword.text as NSString
        var confirm_password:NSString = txtConfirmPassword.text as NSString
        var email:NSString = txtEmail.text as NSString
        
        // Start activity indicator
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        
        if ( username.isEqualToString("") || password.isEqualToString("") || confirm_password.isEqualToString("") || email.isEqualToString("") ) {

            //ensure username, password, email fields aren't left blank
            var alert = UIAlertView(title: "Invalid", message: "Username must be greater then 4 and Password must be greater then 5", delegate: self, cancelButtonTitle: "OK")
            alert.show()

        } else if ( !password.isEqual(confirm_password) ) {

            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Passwords doesn't Match"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
            
            // must add email validation
            // } else if !( email.notValidEmail ) {
            //  validation should be done by parse
            //
            
        } else {
            self.activityIndicator.startAnimating()
            // Create the user
            
            var user = PFUser()
            user.username = username as String
            user.password = password as String
            user.email = email as String
            
            user.signUpInBackgroundWithBlock{
                (succeeded: Bool, error: NSError?) -> Void in
                if (error == nil) {
                    self.activityIndicator.stopAnimating()
                    //redirect to Login page or Logged user in
                    self.redirectToLogin()
                } else {
                    self.activityIndicator.stopAnimating()
//                    let error_msg = error!.userInfo["error"] as! NSString

                    var alertView:UIAlertView = UIAlertView()
                
                    alertView.title = "Sign Up Failed!"
//                    alertView.message = error_msg as String
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                }
            }
        }
    }
    
//    func switchScreen() {
//        println("REDIRECT ME TO LOGIN!!!")
//        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("loginViewController") as! LoginViewController
//        self.navigationController!.pushViewController(vc, animated: true)
//    }
    
    
    
    func redirectToLogin() {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("loginView") as! LoginViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }

    
    @IBAction func gotoLogin(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
