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
let sectionA = Section(title: "Everyday Stressors", objects: ["Emotional Stress", "Hunger", "Dehydration", "Gaps in Between Meals", "Sexual Activity", "Infections", "Too Much Sleep", "Lack of Sleep", "Tiring Activity", "Exercise"])
let sectionB = Section(title: "Foods", objects: ["Alcohol", "MSG", "Onions", "Citrus/Bananas", "Cheese", "Chocolate", "Nitrites", "Processed Foods", "Gluten", "Tyramine", "Dyes in Food", "Artificial Sweetners", "Aspartame", "Saccharin", "Sucralose - Chlorinated Sucrose"])
let sectionC = Section(title: "Hormonal", objects: ["Menstruation", "Birth Control Pill"])
let sectionD = Section(title: "Sensory Overload", objects: ["Light", "Noise", "Motion", "Perfumes"])
let sectionE = Section(title: "Weather", objects: ["High Barometeric Pressure", "High Humidity", "High Temperature", "Wind", "Change in Temperature", "Cold Temperature", "Lightning", "Drop in Barometric Pressure", "Flying"])
let sectionF = Section(title: "Pollution", objects: ["Smoke", "Cigarette Smoke"])
let sectionG = Section(title: "Other", objects: ["Headache Medication (Medication Rebound)"])

let SYMPTOMS = ["Sensitivity to Light", "Sensitivity to Sound", "Sensitivity to Smells", "Dizziness", "Moodiness/Irritability", "Fatigue", "Cravings", "Tinnitus", "Fever", "Decreased Appetite", "Nausea", "Pale", "Hot/Cold", "Body Pain", "Nausea/Vomiting"]
let HELP_MIGRAINE = ["Sleep", "Yoga", "Exercise", "Medications", "Hydration", "Glasses to Prevent Glare", "Caffeine"]
let KEYS = ["FULLNAME", "EMAIL", "TERMSAGREED", "BIRTHCONTROL", "AGE", "GENDER", "NEXTPERIOD", "BIRTHCONTROL", "LMP", "CONDITIONS", "MEDICATION", "HEADACHECONDITIONS", "HEADACHEDURATION", "SYMPTOMS", "TRIGGERS", "HELPMIGRAINE", "NUMBERPROMPTS", "SLEEP", "STRESS", "HEADACHELOCATIONS"]
let DIARY_KEYS = ["SLEEPDURATIONHOURS", "SLEEPDURATIONMINUTES", "SLEEPQUALITY", "STRESSLEVEL", "HADMIGRAINE", "LURKINGMIGRAINE", "SYMPTOMSTODAY", "TRIGGERSTODAY", "HELPMIGRAINETODAY", "MIGRAINESTART", "MIGRAINEEND", "MIGRAINESEVERITY"]
let CONDITIONS = ["High Blood Pressure", "Diabetes", "Heart Attack/Coronary Artery Disease", "Cancer", "Stroke", "Irritable Bowel Syndrome", "Thyroid Problem", "Benign Prostatic Hypertrophy", "Eating Disorders", "Polycystic Ovarian Disease", "Obesity", "HIV", "Depression", "Anxiety", "Schizophrenia/Bipolar Disorder", "Attention Deficit Hyperactivity Disorder", "Attention Deficit Disorder", "Panic Disorder", "Food Allergies"]

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
    
    // this is for missing end time of migraine condition
    if dict["MIGRAINESTART"] != nil && dict["MIGRAINEEND"] == nil {
        prefs.setValue(false, forKey: "MIGRAINEENDENTERED") // end time was not entered
        prefs.setValue(dict["MIGRAINESTART"], forKey: "MISSINGMIGRAINESTART")
        prefs.setValue(curDate, forKey: "MISSINGMIGRAINEENTRY") // the entry ID to which the missing entry will later be updated to
        prefs.synchronize()
        print("missing end date case")
    }
    
    usersRef.childByAppendingPath(NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String).childByAppendingPath(curDate).setValue(dict)
    print("done uploading user diary")
    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
}

// updates (added/removed) medication of the patient to firebase
func sendMedicationToFirebase(medicine: String, isRemoved: Bool) {
    print("sending medication to firebase")
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    // check if user is logged in
    if (NSUserDefaults.standardUserDefaults().valueForKey("uid") == nil || CURRENT_USER.authData == nil) {
        return
    }
    print("user exists")
    
    var dict = [String: AnyObject]()
    dict["Status"] = "Added"
    if isRemoved {
        dict["Status"] = "Removed"
    }
    dict["Medicine"] = medicine
    
    // upload to firebase
    let medicationRef = PATIENT_RECORDS_REF.childByAppendingPath("patient-medication")
    let date = NSDate()
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
    dateFormatter.timeStyle = NSDateFormatterStyle.LongStyle
    let curDate = dateFormatter.stringFromDate(date)
    medicationRef.childByAppendingPath(NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String).childByAppendingPath(curDate).setValue(dict)
    print("done uploading medication")
    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
}

// updates the missing end date of migraine
func sendMissingEndDateToFirebase(missingDate: String) {
    print("sending missing end date to firebase")
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    // check if user is logged in
    if (NSUserDefaults.standardUserDefaults().valueForKey("uid") == nil || CURRENT_USER.authData == nil) {
        return
    }
    print("user exists")
    
    let entryID = prefs.valueForKey("MISSINGMIGRAINEENTRY") as? String
    if entryID != nil && entryID != "" {
        // upload to firebase
        let usersRef = PATIENT_RECORDS_REF.childByAppendingPath("patient-diaries")
        usersRef.childByAppendingPath(NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String).childByAppendingPath(entryID).childByAppendingPath("MIGRAINEEND").setValue(missingDate)
        prefs.removeObjectForKey("MIGRAINEENDENTERED")
        prefs.removeObjectForKey("MISSINGMIGRAINESTART")
        prefs.removeObjectForKey("MISSINGMIGRAINEENTRY")
        prefs.synchronize()
        print("done uploading missing end date")
    } else {
        print("error uploading missing end date to firebase")
    }
    
    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
}

func datesOffset(date:NSDate, date2:NSDate) -> String {
    let dayHourMinuteSecond: NSCalendarUnit = [.Day, .Hour, .Minute, .Second]
    let difference = NSCalendar.currentCalendar().components(dayHourMinuteSecond, fromDate: date, toDate: date2, options: [])
    
    let seconds = "\(difference.second)s"
    let minutes = "\(difference.minute)m" + " " + seconds
    let hours = "\(difference.hour)h" + " " + minutes
    let days = "\(difference.day)d" + " " + hours
    
    if difference.day    > 0 { return days }
    if difference.hour   > 0 { return hours }
    if difference.minute > 0 { return minutes }
    if difference.second > 0 { return seconds }
    return ""
}

func BFLog(message: String, filename: String = #file, line: Int = #line, funcname: String = #function) {
    Bugfender.logLineNumber(line, method: funcname, file: NSURL(fileURLWithPath: filename).lastPathComponent, level: BFLogLevel.Default, tag: nil, message: message)
    #if DEBUG
        NSLog("[\(filename.lastPathComponent):\(line)] \(funcname) - %@", message)
    #endif
}