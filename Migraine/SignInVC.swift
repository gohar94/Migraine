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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInAction(sender: UIButton) {
        // TODO authentication code here
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        prefs.setObject(email.text, forKey: "EMAIL")
        // TODO add the logged in user's name to prefs too and remove the dummy line
//        prefs.setObject(nameStr, forKey: "NAME")
        prefs.setObject("Gohar", forKey: "NAME")
        prefs.setInteger(1, forKey: "ISLOGGEDIN")
        prefs.synchronize()
//        self.performSegueWithIdentifier("goto_welcomefromsignin", sender: self)
        print("signed in")
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
