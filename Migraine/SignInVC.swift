//
//  ViewController2.swift
//  Migraine
//
//  Created by Gohar Irfan on 2/15/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import UIKit
import Firebase

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
                        // to not go to the terms and agreements page since we assume the user has accepted them on registering
                        self.prefs.setBool(true, forKey: "TERMSAGREED")
                        self.prefs.synchronize()
                    }
                    // restore all user defaults from server
                    let ref = Firebase(url: "https://migraine-app.firebaseio.com/patient-records/patient-info/" + authData.uid)
                    print("getting user data for " + authData.uid)
                    ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
                        print(snapshot.value)
                        for key in KEYS {
                            print(key)
                            // check if key exists
                            var val = snapshot.value.objectForKey(key)
                            if (val != nil) {
                                // keep all date objects here and convert them to string explicitly to avoid error
                                // TODO create notifications here, first clear all previous notifications for this app
                                if (key == "SLEEP" || key == "STRESS" || key == "HEADACHE") {
                                    let dateFormatter = NSDateFormatter()
                                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                                    dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
                                    dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
                                    let temp = snapshot.value.objectForKey(key) as? String
                                    if (temp != nil) {
                                        val = dateFormatter.dateFromString(temp!)
                                        print("converted date to string")
                                        print(val)
                                    }
                                }
                                self.prefs.setValue(val, forKey: key)
                                self.prefs.synchronize()
                            } else {
                                print("nil")
                            }
                        }
                        print(NSUserDefaults.standardUserDefaults().dictionaryRepresentation())
                        self.prefs.setBool(false, forKey: "TERMSAGREED")
                        self.prefs.synchronize()
                    })
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
