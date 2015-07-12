//
//  LoginViewController.swift
//  Food For Thought
//
//  Created by Sagar Punhani on 6/16/15.
//  Copyright © 2015 Sagar Punhani. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if PFUser.currentUser() != nil {
            self.performSegueWithIdentifier("Login", sender: self)
        }
    }
    
     
    
    
    @IBAction func login(sender: UIButton) {
        let permissions = ["public_profile"]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    print("User signed up and logged in through Facebook!")
                } else {
                    print("User logged in through Facebook!")
                }
                self.performSegueWithIdentifier("Login", sender: self)
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        }
    }

}