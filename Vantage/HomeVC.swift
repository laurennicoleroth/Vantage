//
//  HomeVC.swift
//  Vantage
//
//  Created by Angel Baek on 4/18/15.
//  Copyright (c) 2015 Apprentice. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ParseUI

class HomeVC: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    
//    @IBAction func login_link(sender: AnyObject) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! UIViewController
//        self.presentViewController(vc, animated: true, completion: nil)
//
//    }
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBAction func logOutTapped(sender: UIButton) {
        PFUser.logOut()
        var currentUser = PFUser.currentUser() //should now be nil
        self.redirectToLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        
        
//        if (PFUser.currentUser() == nil) {
            //redirect me to login page
            
            
            
            
            
            
            
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! UIViewController
//            self.presentViewController(vc, animated: true, completion: nil)

            
            
//            
//            self.logInViewController.fields = PFLogInFields.UsernameAndPassword | PFLogInFields.LogInButton| PFLogInFields.SignUpButton | PFLogInFields.PasswordForgotten | PFLogInFields.DismissButton
//            var logInLogoTitle = UILabel()
//            logInLogoTitle.text = "HERE I AM -- LOG IN LOGO"
//            
//            self.logInViewController.logInView.logo = logInLogoTitle
//            self.logInViewController.delegate = self
//            
//            var signUpLogoTitle = UILabel()
//            signUpLogoTitle.text = "HERE's THE SIGN UP LOGO"
//            
//            self.signUpViewController.signUpView.logo = signUpLogoTitle
//            self.signUpViewController.delegate = self
//            self.logInViewController.signUpController = self.signUpViewController
//        }
//
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        if (isLoggedIn != 1) {
            self.performSegueWithIdentifier("goto_login", sender: self)
        } else {
            self.usernameLabel.text = prefs.valueForKey("USERNAME") as! NSString as String
        }
//    }
    }
    
    
//    @IBAction func login_link(sender: AnyObject) {
//        self.presentViewController(logInViewController, animated: true, completion: nil)
//    }
    
//    // Parse Login Methods
//    func logInViewController(logInController: PFLogInViewController!, shouldBeginLogInWithUsername username: String!, password: String) -> Bool {
//        if (!username.isEmpty || !password.isEmpty) {
//            return true
//        } else {
//            return false
//        }
//    }
//
//    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
//        
//        self.dismissViewControllerAnimated(true, completion: nil)
//        
//    }
//    
//    func logInViewController(logInController: PFLogInViewController!, didFailToLogInWithError error: NSError!) {
//        println("Failed to login...")
//    }
//    
//    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController) {
//        
//    }
//    
//    // Parse Signup Methods
//    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
//        
//        self.dismissViewControllerAnimated(true, completion: nil)
//        
//    }
//    func signUpViewController(signUpController: PFSignUpViewController!, didFailToSignUpWithError error: NSError!) {
//        
//        println("FAiled to sign up...")
//        
//    }
//    
//    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController!) {
//        
//        println("User dismissed sign up.")
//        
//    }
    
    func redirectToLogin() {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("loginView") as! LoginViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }




}
