//
//  ChangePasswordVC.swift
//  Migraine
//
//  Created by Gohar Irfan on 4/16/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changePassword(newPasswordStr: String) {
        let emailStr = prefs.valueForKey("EMAIL") as? String
        let passwordStr = prefs.valueForKey("PASSWORD") as? String
        if (emailStr != nil && passwordStr != nil) {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            FIREBASE_REF.changePasswordForUser(emailStr, fromOld: passwordStr, toNew: newPasswordStr, withCompletionBlock: { error in
                if error != nil {
                    // There was an error processing the request
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    let alert = UIAlertController(title: "Error", message: error.userInfo.debugDescription, preferredStyle: .Alert)
                    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    // Password changed successfully
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    let alert = UIAlertController(title: "Success", message: "Password changed!", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "OK", style: .Default) {
                        UIAlertAction in
                        prefs.setObject(newPasswordStr, forKey: "PASSWORD")
                        self.performSegueWithIdentifier("goto_welcomefromchangepassword", sender: self)
                    }
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                    return
                }
            })
        } else {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            let alert = UIAlertController(title: "Error", message: "Could not find a valid email or password. Please try to sign in again!", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func changePasswordAction(sender: UIButton) {
        if (password.text == "" || confirmPassword.text == "") {
            let alert = UIAlertController(title: "Error", message: "Please enter a valid new password in both the above fields!", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        if (password.text != confirmPassword.text) {
            let alert = UIAlertController(title: "Error", message: "Please make sure both the passwords match!", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        changePassword(password.text!)
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
