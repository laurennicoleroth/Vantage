//
//  HomeVC.swift
//  Vantage
//
//  Created by Angel Baek on 4/18/15.
//  Copyright (c) 2015 Apprentice. All rights reserved.
//

//import Foundation
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

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.loginSetUp()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Parse Login
    func logInViewController(logInController: PFLogInViewController!, shouldBeginLogInWithUsername username: String!, password: String) -> Bool {
        if (!username.isEmpty || !password.isEmpty) {
            return true
        } else {
            return false
        }
    }

    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {

        self.dismissViewControllerAnimated(true, completion: nil)

    }

    func logInViewController(logInController: PFLogInViewController!, didFailToLogInWithError error: NSError!) {
        println("Failed to login...")
    }

    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController) {

    }

    // MARK: - Parse Signup
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {

        self.dismissViewControllerAnimated(true, completion: nil)

    }
    func signUpViewController(signUpController: PFSignUpViewController!, didFailToSignUpWithError error: NSError!) {

        println("FAiled to sign up...")

    }

    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController!) {
        
        println("User dismissed sign up.")
        
    }
    
    @IBAction func logOutAction(sender: AnyObject) {
        PFUser.logOut()
        self.loginSetUp()
        
    }
    
    func loginSetUp(){
        if (PFUser.currentUser() == nil) {
            
            var logInViewController = PFLogInViewController()
            logInViewController.delegate = self
            
            var signUpViewController = PFSignUpViewController()
            signUpViewController.delegate = self
            
            logInViewController.signUpController = signUpViewController
            self.presentViewController(logInViewController, animated: true, completion: nil)
        }

        
    }
    
    
    func redirectToLogin() {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("loginView") as! LoginViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }




}
