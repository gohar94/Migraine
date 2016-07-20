//
//  ViewController1.swift
//  Migraine
//
//  Created by Gohar Irfan on 2/16/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import UIKit

class WelcomeVC: BaseViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var dailyButton: UIView!
    
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.addSlideMenuButton()
        print("app started again view did load")
        BFLog("app started again view did load")
        // DEBUG ONLY
        print(NSUserDefaults.standardUserDefaults().dictionaryRepresentation())
        let dict = NSUserDefaults.standardUserDefaults().dictionaryRepresentation()
        for key in dict.keys {
            print(key)
            BFLog(key)
            let val = dict[key] as? String
            if val != nil {
                print(val!)
                BFLog(val!)
            }
        }
        // induce crash
//        let aa = [String]()
//        let bb = aa[1]
        //
        
        let isEndTimeEntered = prefs.valueForKey("MIGRAINEENDENTERED") as? Bool
        if isEndTimeEntered != nil {
            if isEndTimeEntered == false {
                let startDateTime = prefs.valueForKey("MISSINGMIGRAINESTART") as? String
                if startDateTime != nil {
                    if startDateTime != "" {
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
                        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
                        let startDateTimeTemp = dateFormatter.dateFromString(startDateTime!)!
                        let date = NSDate()
                        let dif = datesOffset(startDateTimeTemp, date2: date)
                        let alert = UIAlertController(title: "Warning", message: "You have had a migraine for " + dif + ". \n \n Please enter the End Time now.", preferredStyle: .Alert)
                        let action = UIAlertAction(title: "Enter Now", style: .Default) { (action) -> Void in
                            self.performSegueWithIdentifier("goto_missingendtimefromwelcome", sender: self)
                        }
                        let action2 = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
                        alert.addAction(action)
                        alert.addAction(action2)
                        self.presentViewController(alert, animated: true, completion: nil)
                        return
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if (NSUserDefaults.standardUserDefaults().valueForKey("uid") == nil || CURRENT_USER.authData == nil) {
            print("this is called here hah")
            BFLog("this is called here hah")
            self.performSegueWithIdentifier("goto_signin", sender: self)
        }
        print("app started again view did appear")
        BFLog("app started again view did load")
    }
    
    @IBAction func logoutAction(sender: UITextField) {
        CURRENT_USER.unauth()
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
        prefs.synchronize()
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        prefs.synchronize()
        for notification in (UIApplication.sharedApplication().scheduledLocalNotifications )! {
            UIApplication.sharedApplication().cancelLocalNotification(notification)
            print("deleting notif")
            BFLog("deleting notif")
        }
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        self.performSegueWithIdentifier("goto_signin", sender: self)
    }
    
    @IBAction func dailyDiaryAction(sender: UIButton) {
        let termsAgreed = prefs.valueForKey("TERMSAGREED") as? Bool
        if (termsAgreed != nil) {
            if (termsAgreed == false) {
                print("ll1")
                BFLog("ll1")
                self.performSegueWithIdentifier("goto_introfromwelcome", sender: self)
                return
            }
        } else {
            print("ll2")
            BFLog("ll2")
            self.performSegueWithIdentifier("goto_introfromwelcome", sender: self)
            return
        }
        self.performSegueWithIdentifier("goto_dailysurveyfromwelcome", sender: self)
    }
    
    @IBAction func passwordReset(sender: UIButton) {
        self.performSegueWithIdentifier("goto_changepassword", sender: self)
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
