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
    
    // this is code reuse, needs fixing
    func checkNotificationsEnabled() -> Bool {
        guard let settings = UIApplication.sharedApplication().currentUserNotificationSettings() else { return false }
        
        if settings.types == .None {
            print("settings none")
            // make sure this warning comes up only once on one app launch
            if toAlert {
                let ac = UIAlertController(title: "Can't prompt!", message: "Notifications not enabled by user. Enable them from Settings > Notifications > Migraine", preferredStyle: .Alert)
                ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                presentViewController(ac, animated: true, completion: nil)
                toAlert = false
            } else {
                print("to alert is false")
            }
            return false
        } else {
            return true
        }
    }
    
    func notifications(key: String) {
        if !checkNotificationsEnabled() {
            print("notifications not enabled")
            return
        }
        print("notifications enabled")
        let inPrefs = prefs.valueForKey(key) as? NSDate
        if inPrefs != nil {
            print(inPrefs)
            print("Setting notif")
            for notification in (UIApplication.sharedApplication().scheduledLocalNotifications )! {
                if (notification.userInfo!["TYPE"]) != nil {
                    if (notification.userInfo!["TYPE"] as! String == key) {
                        UIApplication.sharedApplication().cancelLocalNotification(notification)
                        print("deleting notif")
                        break
                    }
                }
            }
            let notification = UILocalNotification()
            notification.fireDate = inPrefs
            notification.repeatInterval = NSCalendarUnit.Day
            notification.timeZone = NSCalendar.currentCalendar().timeZone
            notification.alertBody = "Please write your migraine diary. Thanks!"
            notification.hasAction = true
            notification.alertAction = "open"
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.userInfo = ["TYPE": key ]
            notification.category = "PROMPT"
            notification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
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
                    self.prefs.setObject(emailStr, forKey: "EMAIL")
                    self.prefs.setObject(passwordStr, forKey: "PASSWORD")
                    self.prefs.synchronize()
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
                                self.notifications(key)
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
