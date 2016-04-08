//
//  ViewController2.swift
//  Migraine
//
//  Created by Gohar Irfan on 2/15/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if (NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil && CURRENT_USER.authData != nil) {
            print("already signed in")
            self.performSegueWithIdentifier("goto_welcomefromsignin", sender: self)
        } else {
            print("not signed in")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInAction(sender: UIButton) {
        let emailStr = self.email.text
        let passwordStr = self.password.text
        
        if (emailStr != "" && passwordStr != "") {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            FIREBASE_REF.authUser(emailStr, password: passwordStr, withCompletionBlock: { (error, authData) -> Void in
                if (error == nil) {
                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    print("Logged in!")
                    let termsAgreed = self.prefs.valueForKey("TERMSAGREED") as? Bool
                    if (termsAgreed != nil) {
                        if (termsAgreed == false) {
                            // it will never come here, just sanity stuff
                            self.prefs.setBool(true, forKey: "TERMSAGREED")
                            self.prefs.synchronize()
                        }
                    } else {
                        self.prefs.setBool(true, forKey: "TERMSAGREED")
                        self.prefs.synchronize()
                    }
                    // TODO restore all user defaults from server
                    self.performSegueWithIdentifier("goto_welcomefromsignin", sender: self)
                } else {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    let alert = UIAlertController(title: "Error", message: error.userInfo.debugDescription, preferredStyle: .Alert)
                    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        } else {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            let alert = UIAlertController(title: "Error", message: "Enter email and password", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
