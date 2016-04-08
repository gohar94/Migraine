//
//  BaseService.swift
//  Migraine
//
//  Created by Gohar Irfan on 4/8/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import Foundation
import Firebase

let BASE_URL = "https://migraine-app.firebaseio.com"
let FIREBASE_REF = Firebase(url: BASE_URL)
var CURRENT_USER: Firebase
{
    let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
    let currentUser = Firebase(url: "\(FIREBASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)
    return currentUser!
}

let PATIENT_RECORDS_REF = Firebase(url: "https://migraine-app.firebaseio.com/patient-records")
let KEYS = ["TERMSAGREED", "BIRTHCONTROL", "AGE", "GENDER", "NEXTPERIOD", "BIRTHCONTROL", "LMP", "CONDITIONS", "MEDICATION", "HEADACHECONDITIONS", "HEADACHEDURATION", "SYMPTOMS", "TRIGGERS", "HELPMIGRAINE", "HELPMIGRAINEALL", "NUMBERPROMPTS", "SLEEP", "STRESS", "HEADACHE"]

//TODO receive data from firebase and populate user default prefs

func sendDataToFirebase() {
    print("sending")
    // check if user is logged in
    if (NSUserDefaults.standardUserDefaults().valueForKey("uid") == nil || CURRENT_USER.authData == nil) {
        return
    }
    print("user exists")
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    var dict = [String: AnyObject]()
    // iterate over keys
    for key in KEYS {
        print(key)
        // check if key exists
        var val = prefs.valueForKey(key)
        if (val != nil) {
            // keep all date objects here and convert them to string explicitly to avoid error
            if (key == "SLEEP" || key == "STRESS" || key == "HEADACHE") {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
                dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
                let temp = prefs.valueForKey(key) as? NSDate
                val = dateFormatter.stringFromDate(temp!)
                print("converted date to string")
                print(val)
            }
            dict[key] = val
        } else {
            print("nil")
        }
    }
    print(dict)
    // upload to firebase
    let usersRef = PATIENT_RECORDS_REF.childByAppendingPath("patient-info")
    usersRef.childByAppendingPath(NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String).setValue(dict)
    print("done uploading")
}