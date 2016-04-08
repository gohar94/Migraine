//
//  ViewController3.swift
//  Migraine
//
//  Created by Gohar Irfan on 2/15/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {

    @IBOutlet weak var name: UITextField!
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
    
    @IBAction func registerAction(sender: UIButton) {
        
        let emailStr = self.email.text
        let passwordStr = self.password.text
        
        if (emailStr != "" && passwordStr != "") {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            FIREBASE_REF.createUser(emailStr, password: passwordStr, withValueCompletionBlock: { (error, authData) -> Void in
                if (error == nil) {
                    print("created user")
                    FIREBASE_REF.authUser(emailStr, password: passwordStr, withCompletionBlock: { (error, authData) -> Void in
                        if (error == nil) {
                            print("authenticated user")
                            NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                            print("Logged in!")
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                            self.performSegueWithIdentifier("goto_welcomefromregister", sender: self)
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
                    let alert = UIAlertController(title: "Error", message: error.userInfo.debugDescription, preferredStyle: .Alert)
                    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        } else {
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
