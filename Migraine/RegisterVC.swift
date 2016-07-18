//
//  ViewController3.swift
//  Migraine
//
//  Created by Gohar Irfan on 2/15/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var fullName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        email.delegate = self
        password.delegate = self
        fullName.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerAction(sender: UIButton) {
        
        let emailStr = self.email.text
        let passwordStr = self.password.text
        let fullNameStr = self.fullName.text
        
        if (emailStr != "" && passwordStr != "" && fullNameStr != "") {
            email.resignFirstResponder()
            password.resignFirstResponder()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            FIREBASE_REF.createUser(emailStr, password: passwordStr, withValueCompletionBlock: { (error, authData) -> Void in
                if (error == nil) {
                    print("created user")
                    BFLog("created user")
                    FIREBASE_REF.authUser(emailStr, password: passwordStr, withCompletionBlock: { (error, authData) -> Void in
                        if (error == nil) {
                            print("authenticated user")
                            BFLog("authenticated user")
                            NSUserDefaults.standardUserDefaults().setObject(emailStr, forKey: "EMAIL")
                            NSUserDefaults.standardUserDefaults().setObject(passwordStr, forKey: "PASSWORD")
                            NSUserDefaults.standardUserDefaults().setObject(fullNameStr, forKey: "FULLNAME")
                            NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                            print("Logged in!")
                            BFLog("Logged in!")
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
            let alert = UIAlertController(title: "Error", message: "Enter full name, email and password", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
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
