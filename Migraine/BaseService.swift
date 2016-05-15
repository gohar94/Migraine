//
//  BaseService.swift
//  Migraine
//
//  Created by Gohar Irfan on 4/8/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import Foundation
import Firebase

let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
let BASE_URL = "https://migraine-app.firebaseio.com"
let FIREBASE_REF = Firebase(url: BASE_URL)
let PATIENT_RECORDS_REF = Firebase(url: "https://migraine-app.firebaseio.com/patient-records")

var CURRENT_USER: Firebase
{
    let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
    let currentUser = Firebase(url: "\(FIREBASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)
    return currentUser!
}

struct Section {
    
    var heading : String
    var items : [String]
    var collapsed : Bool
    
    init(title: String, objects : [String]) {
        heading = title
        items = objects
        collapsed = false
    }
    
}

// for triggers
let sectionA = Section(title: "Everyday Stressors", objects: ["Emotional Stress", "Hunger", "Dehydration", "Gaps in between meals", "Sexual Activity", "Infections", "Too much sleep", "Lack of sleep", "Tiring Activity", "Exercise"])
let sectionB = Section(title: "Foods", objects: ["Alcohol", "MSG", "Onions", "Citrus/Bananas", "Cheese", "Chocolate", "Nitrites", "Processed Foods", "Gluten", "Tyramine", "Dyes in food", "Artificial Sweetners", "Aspartame", "Saccharin", "Sucralose - Chlorinated sucrose"])
let sectionC = Section(title: "Hormonal", objects: ["Menstruation", "Birth Control Pill"])
let sectionD = Section(title: "Sensory Overload", objects: ["Light", "Noise", "Motion", "Perfumes"])
let sectionE = Section(title: "Weather", objects: ["High Barometeric Pressure", "High Humidity", "High Temperature", "Wind", "Change in temperature", "Cold Temperature", "Lightning", "Drop in barometric pressure", "Flying"])
let sectionF = Section(title: "Pollution", objects: ["Smoke", "Cigarette Smoke"])
let sectionG = Section(title: "Other", objects: ["Headache Medication (Medication Rebound)"])

let SYMPTOMS = ["Sensitivity to Light", "Sensitivity to Sound", "Sensitivity to Smells", "Dizziness", "Moodiness/Irritability", "Fatigue", "Cravings", "Tinnitus", "Fever", "Decreased Appetite", "Nausea", "Pale", "Hot/Cold", "Body Pain", "Nausea/Vomiting"]
let HELP_MIGRAINE = ["Sleep", "Yoga", "Exercise", "Medications", "Hydration", "Glasses to prevent glare", "Caffeine"]
let KEYS = ["FULLNAME", "EMAIL", "TERMSAGREED", "BIRTHCONTROL", "AGE", "GENDER", "NEXTPERIOD", "BIRTHCONTROL", "LMP", "CONDITIONS", "MEDICATION", "HEADACHECONDITIONS", "HEADACHEDURATION", "SYMPTOMS", "TRIGGERS", "HELPMIGRAINE", "NUMBERPROMPTS", "SLEEP", "STRESS", "HEADACHELOCATIONS"]
let DIARY_KEYS = ["SLEEPDURATIONHOURS", "SLEEPDURATIONMINUTES", "SLEEPQUALITY", "STRESSLEVEL", "HADMIGRAINE", "LURKINGMIGRAINE", "SYMPTOMSTODAY", "TRIGGERSTODAY", "HELPMIGRAINETODAY", "MIGRAINESEVERITY", "MIGRAINESEVERITY"]

var toAlert = true

// sends user data (profile) to firebase
func sendDataToFirebase() {
    print("sending")
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
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
            if (key == "SLEEP" || key == "STRESS") {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
                dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
                let temp = prefs.valueForKey(key) as? NSDate
                if (temp != nil) {
                    val = dateFormatter.stringFromDate(temp!)
                    print("converted date to string")
                    print(val)
                }
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
    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
}

// sends user daily diary to firebase
func sendDiaryToFirebase() {
    print("sending diary to firebase")
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    // check if user is logged in
    if (NSUserDefaults.standardUserDefaults().valueForKey("uid") == nil || CURRENT_USER.authData == nil) {
        return
    }
    print("user exists")
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    var dict = [String: AnyObject]()
    // iterate over keys
    for key in DIARY_KEYS {
        print(key)
        // check if key exists
        let val = prefs.valueForKey(key)
        if (val != nil) {
            dict[key] = val
            // we dont want to persist the data of daily diary once it is sent
            prefs.removeObjectForKey(key)
            prefs.synchronize()
        } else {
            print("nil")
        }
    }
    print(dict)
    // upload to firebase
    let usersRef = PATIENT_RECORDS_REF.childByAppendingPath("patient-diaries")
    let date = NSDate()
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
    dateFormatter.timeStyle = NSDateFormatterStyle.LongStyle
    let curDate = dateFormatter.stringFromDate(date)
    usersRef.childByAppendingPath(NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String).childByAppendingPath(curDate).setValue(dict)
    print("done uploading user diary")
    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
}