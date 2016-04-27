//
//  PromptsVC.swift
//  Migraine
//
//  Created by Gohar Irfan on 3/2/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import UIKit

class PromptsVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var numberTableView: UITableView!
    @IBOutlet var sleepTime: UITextField!
    @IBOutlet var stressTime: UITextField!
    
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    var numbers = ["1", "2"]
    var selectedNumber = String()
    
    func onlyOneNotification(defaultValue: Bool) {
        if (selectedNumber == "1") {
            stressTime.enabled = false
            for notification in (UIApplication.sharedApplication().scheduledLocalNotifications )! {
                if (notification.userInfo!["TYPE"]) != nil {
                    if (notification.userInfo!["TYPE"] as! String == "STRESS") {
                        UIApplication.sharedApplication().cancelLocalNotification(notification)
                        print("deleting notif")
                        Logger.log("deleting")
                        break
                    }
                }
            }
            prefs.setObject(nil, forKey: "STRESS")
            prefs.synchronize()
        } else {
            stressTime.enabled = true
            if (defaultValue) {
                // set default value here
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat =  "hh:mm a"
                let date = dateFormatter.dateFromString("07:30 PM")
                prefs.setObject(date, forKey: "STRESS")
                prefs.synchronize()
                notifications("STRESS")
                stressTime.text = dateFormatter.stringFromDate(date!)
            }
        }
    }
    
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
//            let oldCount = UIApplication.sharedApplication().applicationIconBadgeNumber
//            notification.applicationIconBadgeNumber = oldCount + 1
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .Plain, target: self, action: "skipTapped")
        
        
        let numbersInPrefs = prefs.valueForKey("NUMBERPROMPTS") as? String
        if numbersInPrefs != nil {
            selectedNumber = prefs.valueForKey("NUMBERPROMPTS") as! String
            onlyOneNotification(false)
        } else {
            // default number of prompts = 2
            selectedNumber = "2"
            prefs.setObject(selectedNumber, forKey: "NUMBERPROMPTS")
        }
        print(selectedNumber)
        
        checkNotificationsEnabled() // remind user to turn on notification
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let sleepInPrefs = prefs.valueForKey("SLEEP") as? NSDate
        if sleepInPrefs != nil {
            sleepTime.text = dateFormatter.stringFromDate(sleepInPrefs!)
        } else {
            // set default value here
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat =  "hh:mm a"
            let date = dateFormatter.dateFromString("10:00 AM")
            prefs.setObject(date, forKey: "SLEEP")
            prefs.synchronize()
            notifications("SLEEP")
            sleepTime.text = dateFormatter.stringFromDate(date!)
        }
        let stressInPrefs = prefs.valueForKey("STRESS") as? NSDate
        if stressInPrefs != nil {
            stressTime.text = dateFormatter.stringFromDate(stressInPrefs!)
        } else {
            if numbersInPrefs == "2" {
                // set default value here
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat =  "hh:mm a"
                let date = dateFormatter.dateFromString("07:30 PM")
                prefs.setObject(date, forKey: "STRESS")
                prefs.synchronize()
                notifications("STRESS")
                stressTime.text = dateFormatter.stringFromDate(date!)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numbers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel!.text = numbers[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if selectedNumber == (cell.textLabel?.text)! {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            cell.tintColor = UIColor(red: 152.0/255.0, green: 193.0/255.0, blue: 235.0/255.0, alpha: 1.0)
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedRow = tableView.cellForRowAtIndexPath(indexPath)!
        // clear existing selection
        for (var row = 0; row < tableView.numberOfRowsInSection(0); row++) {
            tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0))?.accessoryType = UITableViewCellAccessoryType.None
        }
        if selectedRow.accessoryType == UITableViewCellAccessoryType.None {
            selectedRow.accessoryType = UITableViewCellAccessoryType.Checkmark
            selectedRow.tintColor = UIColor(red: 152.0/255.0, green: 193.0/255.0, blue: 235.0/255.0, alpha: 1.0)
            selectedNumber = numbers[indexPath.row]
            prefs.setObject(selectedNumber, forKey: "NUMBERPROMPTS")
            prefs.synchronize()
            print(selectedNumber)
            onlyOneNotification(true)
        }
    }

    @IBAction func sleepAction(sender: UITextField) {
        let inputView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 240))
        let datePickerView  : UIDatePicker = UIDatePicker(frame: CGRectMake(0, 40, 0, 0))
        datePickerView.datePickerMode = UIDatePickerMode.Time
        inputView.addSubview(datePickerView) // add date picker to UIView
        let doneButton = UIButton(frame: CGRectMake((self.view.frame.size.width/2) - (100/2), 0, 100, 50))
        doneButton.setTitle("Done", forState: UIControlState.Normal)
        doneButton.setTitle("Done", forState: UIControlState.Highlighted)
        doneButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        inputView.addSubview(doneButton) // add Button to UIView
        doneButton.addTarget(self, action: "doneSleepButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside) // set button click event
        sender.inputView = inputView
        datePickerView.addTarget(self, action: Selector("datePickerSleepValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        datePickerSleepValueChanged(datePickerView) // Set the date on start.
    }
    
    func datePickerSleepValueChanged(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        let selectedDateStr = dateFormatter.stringFromDate(sender.date)
        print(selectedDateStr)
        sleepTime.text = dateFormatter.stringFromDate(sender.date)
        print(sender.date)
        prefs.setValue(sender.date, forKey: "SLEEP")
        prefs.synchronize()
    }
    
    func doneSleepButtonPressed(sender: UIButton) {
        sleepTime.resignFirstResponder() // To resign the inputView on clicking done.
        notifications("SLEEP")
    }
    
    @IBAction func stressAction(sender: UITextField) {
        let inputView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 240))
        let datePickerView  : UIDatePicker = UIDatePicker(frame: CGRectMake(0, 40, 0, 0))
        datePickerView.datePickerMode = UIDatePickerMode.Time
        inputView.addSubview(datePickerView) // add date picker to UIView
        let doneButton = UIButton(frame: CGRectMake((self.view.frame.size.width/2) - (100/2), 0, 100, 50))
        doneButton.setTitle("Done", forState: UIControlState.Normal)
        doneButton.setTitle("Done", forState: UIControlState.Highlighted)
        doneButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        inputView.addSubview(doneButton) // add Button to UIView
        doneButton.addTarget(self, action: "doneStressButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside) // set button click event
        sender.inputView = inputView
        datePickerView.addTarget(self, action: Selector("datePickerStressValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        datePickerStressValueChanged(datePickerView) // Set the date on start.
    }
    
    func datePickerStressValueChanged(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        let selectedDateStr = dateFormatter.stringFromDate(sender.date)
        print(selectedDateStr)
        stressTime.text = dateFormatter.stringFromDate(sender.date)
        prefs.setValue(sender.date, forKey: "STRESS")
        prefs.synchronize()
    }
    
    func doneStressButtonPressed(sender: UIButton) {
        stressTime.resignFirstResponder() // To resign the inputView on clicking done.
        // TODO remove previous notification for stress if
        notifications("STRESS")
    }
    
    @IBAction func nextButtonAction(sender: UIButton) {
        sendDataToFirebase()
        self.performSegueWithIdentifier("goto_dailysurvey", sender: self)
    }
    
    func skipTapped() {
        sendDataToFirebase()
        self.openViewControllerBasedOnIdentifier("DailySurveyVC")
        print("skip")
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
