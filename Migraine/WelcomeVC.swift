//
//  ViewController1.swift
//  Migraine
//
//  Created by Gohar Irfan on 2/16/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var dailyButton: UIView!
    
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if (NSUserDefaults.standardUserDefaults().valueForKey("uid") == nil || CURRENT_USER.authData == nil) {
            print("this is called here hah")
            self.performSegueWithIdentifier("goto_signin", sender: self)
        }
    }
    
    @IBAction func logoutAction(sender: UITextField) {
        CURRENT_USER.unauth()
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
        self.performSegueWithIdentifier("goto_signin", sender: self)
    }
    
    @IBAction func dailyDiaryAction(sender: UIButton) {
        let termsAgreed = prefs.valueForKey("TERMSAGREED") as? Bool
        if (termsAgreed != nil) {
            if (termsAgreed == false) {
                print("ll1")
                self.performSegueWithIdentifier("goto_introfromwelcome", sender: self)
                return
            }
        } else {
            print("ll2")
            self.performSegueWithIdentifier("goto_introfromwelcome", sender: self)
            return
        }
        self.performSegueWithIdentifier("goto_dailysurveyfromwelcome", sender: self)
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
