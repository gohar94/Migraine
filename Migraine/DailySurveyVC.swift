//
//  DailySurveyVC.swift
//  Migraine
//
//  Created by Gohar Irfan on 4/8/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import UIKit

class DailySurveyVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var sleepDurationHours: UITextField!
    @IBOutlet weak var sleepDurationMinutes: UITextField!
    @IBOutlet weak var sleepQuality: UITextField!
    @IBOutlet weak var stress: UITextField!
    @IBOutlet weak var hadMigraine: UITextField!
    
    let hourOptions = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24"]
    let minuteOptions = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", "60"]
    let scaleOptions = ["1", "2", "3", "4", "5"]
    let hadMigraineOptions = ["Yes", "No"]
    
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    enum PickerViewTag: Int {
        // Integer values will be implicitly supplied; you could optionally set your own values
        case PickerViewSleepDurationHours
        case PickerViewSleepDurationMinutes
        case PickerViewSleepQuality
        case PickerViewStress
        case PickerViewHadMigraine
    }

// TODO send date on pressing next
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//      // Do we want to show the persisted data or not?
//        let sleepDurationHoursInPrefs = prefs.valueForKey("SLEEPDURATIONHOURS") as? String
//        if sleepDurationHoursInPrefs != nil {
//            sleepDurationHours.text = prefs.valueForKey("SLEEPDURATIONHOURS") as? String
//        }
//        let sleepDurationMinutesInPrefs = prefs.valueForKey("SLEEPDURATIONMINUTES") as? String
//        if sleepDurationMinutesInPrefs != nil {
//            sleepDurationMinutes.text = prefs.valueForKey("SLEEPDURATIONMINUTES") as? String
//        }
//        let sleepQualtiyInPrefs = prefs.valueForKey("SLEEPQUALITY") as? String
//        if sleepQualtiyInPrefs != nil {
//            sleepQuality.text = prefs.valueForKey("SLEEPQUALITY") as? String
//        }
//        let stressInPrefs = prefs.valueForKey("STRESSLEVEL") as? String
//        if stressInPrefs != nil {
//            stress.text = prefs.valueForKey("STRESSLEVEL") as? String
//        }
//        let hadMigraineInPrefs = prefs.valueForKey("HADMIGRAINE") as? String
//        if hadMigraineInPrefs != nil {
//            hadMigraine.text = prefs.valueForKey("HADMIGRAINE") as? String
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let tag = PickerViewTag(rawValue: pickerView.tag) {
            switch tag {
            case .PickerViewSleepDurationHours:
                return hourOptions.count
            case .PickerViewSleepDurationMinutes:
                return minuteOptions.count
            case .PickerViewSleepQuality:
                return scaleOptions.count
            case .PickerViewStress:
                return scaleOptions.count
            case .PickerViewHadMigraine:
                return hadMigraineOptions.count
            }
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let tag = PickerViewTag(rawValue: pickerView.tag) {
            switch tag {
            case .PickerViewSleepDurationHours:
                return hourOptions[row]
            case .PickerViewSleepDurationMinutes:
                return minuteOptions[row]
            case .PickerViewSleepQuality:
                return scaleOptions[row]
            case .PickerViewStress:
                return scaleOptions[row]
            case .PickerViewHadMigraine:
                return hadMigraineOptions[row]
            }
        }
        return ""
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let tag = PickerViewTag(rawValue: pickerView.tag) {
            switch tag {
            case .PickerViewSleepDurationHours:
                sleepDurationHours.text = hourOptions[row]
            case .PickerViewSleepDurationMinutes:
                sleepDurationMinutes.text = minuteOptions[row]
            case .PickerViewSleepQuality:
                sleepQuality.text = scaleOptions[row]
            case .PickerViewStress:
                stress.text = scaleOptions[row]
            case .PickerViewHadMigraine:
                hadMigraine.text = hadMigraineOptions[row]
            }
        }
    }
    
    
    @IBAction func sleepDurationHoursAction(sender: UITextField) {
        let pickerView = UIPickerView()
        pickerView.tag = PickerViewTag.PickerViewSleepDurationHours.rawValue
        pickerView.delegate = self
        sleepDurationHours.inputView = pickerView
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.BlackTranslucent
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.backgroundColor = UIColor.blackColor()
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneSleepDurationHoursPressed:")
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.whiteColor()
        label.text = "Hours"
        label.textAlignment = NSTextAlignment.Center
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([textBtn,flexSpace,doneButton], animated: true)
        sleepDurationHours.inputAccessoryView = toolBar
        sleepDurationHours.text = hourOptions[0]
        prefs.setObject(sleepDurationHours.text, forKey: "SLEEPDURATIONHOURS")
        prefs.synchronize()
    }
    
    func doneSleepDurationHoursPressed(sender: UIBarButtonItem) {
        prefs.setObject(sleepDurationHours.text, forKey: "SLEEPDURATIONHOURS")
        prefs.synchronize()
        sleepDurationHours.resignFirstResponder()
    }

    @IBAction func sleepDurationMinutesAction(sender: UITextField) {
        let pickerView = UIPickerView()
        pickerView.tag = PickerViewTag.PickerViewSleepDurationMinutes.rawValue
        pickerView.delegate = self
        sleepDurationMinutes.inputView = pickerView
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.BlackTranslucent
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.backgroundColor = UIColor.blackColor()
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneSleepDurationMinutesPressed:")
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.whiteColor()
        label.text = "Minutes"
        label.textAlignment = NSTextAlignment.Center
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([textBtn,flexSpace,doneButton], animated: true)
        sleepDurationMinutes.inputAccessoryView = toolBar
        sleepDurationMinutes.text = minuteOptions[0]
        prefs.setObject(sleepDurationMinutes.text, forKey: "SLEEPDURATIONMINUTES")
        prefs.synchronize()
    }
    
    func doneSleepDurationMinutesPressed(sender: UIBarButtonItem) {
        prefs.setObject(sleepDurationMinutes.text, forKey: "SLEEPDURATIONMINUTES")
        prefs.synchronize()
        sleepDurationMinutes.resignFirstResponder()
    }
    
    @IBAction func sleepQualityAction(sender: UITextField) {
        let pickerView = UIPickerView()
        pickerView.tag = PickerViewTag.PickerViewSleepQuality.rawValue
        pickerView.delegate = self
        sleepQuality.inputView = pickerView
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.BlackTranslucent
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.backgroundColor = UIColor.blackColor()
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneSleepQualityPressed:")
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.whiteColor()
        label.text = "Quality"
        label.textAlignment = NSTextAlignment.Center
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([textBtn,flexSpace,doneButton], animated: true)
        sleepQuality.inputAccessoryView = toolBar
        sleepQuality.text = scaleOptions[0]
        prefs.setObject(sleepQuality.text, forKey: "SLEEPQUALITY")
        prefs.synchronize()
    }
    
    func doneSleepQualityPressed(sender: UIBarButtonItem) {
        sleepQuality.resignFirstResponder()
        prefs.setObject(sleepQuality.text, forKey: "SLEEPQUALITY")
        prefs.synchronize()
    }
    
    @IBAction func stressAction(sender: UITextField) {
        let pickerView = UIPickerView()
        pickerView.tag = PickerViewTag.PickerViewStress.rawValue
        pickerView.delegate = self
        stress.inputView = pickerView
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.BlackTranslucent
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.backgroundColor = UIColor.blackColor()
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneStressPressed:")
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.whiteColor()
        label.text = "Stress"
        label.textAlignment = NSTextAlignment.Center
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([textBtn,flexSpace,doneButton], animated: true)
        stress.inputAccessoryView = toolBar
        stress.text = scaleOptions[0]
        prefs.setObject(stress.text, forKey: "STRESSLEVEL")
        prefs.synchronize()
    }
    
    func doneStressPressed(sender: UIBarButtonItem) {
        prefs.setObject(stress.text, forKey: "STRESSLEVEL")
        prefs.synchronize()
        stress.resignFirstResponder()
    }
    
    @IBAction func hadMigraineAction(sender: UITextField) {
        let pickerView = UIPickerView()
        pickerView.tag = PickerViewTag.PickerViewHadMigraine.rawValue
        pickerView.delegate = self
        hadMigraine.inputView = pickerView
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.BlackTranslucent
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.backgroundColor = UIColor.blackColor()
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(DailySurveyVC.doneHadMigrainePressed(_:)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.whiteColor()
        label.text = "Migraine"
        label.textAlignment = NSTextAlignment.Center
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([textBtn,flexSpace,doneButton], animated: true)
        hadMigraine.inputAccessoryView = toolBar
        hadMigraine.text = hadMigraineOptions[0]
        prefs.setObject(hadMigraine.text, forKey: "HADMIGRAINE")
        prefs.synchronize()
    }
    
    func doneHadMigrainePressed(sender: UIBarButtonItem) {
        prefs.setObject(hadMigraine.text, forKey: "HADMIGRAINE")
        prefs.synchronize()
        hadMigraine.resignFirstResponder()
    }
    
    @IBAction func nextButtonAction(sender: UIButton) {
        print("Next")
        print(hadMigraine.text!)
        sendDiaryToFirebase()
        if (hadMigraine != nil) {
            if (hadMigraine.text! == "No") {
                self.performSegueWithIdentifier("goto_nomigrainetoday", sender: self)
                return
            } else if (hadMigraine.text! == "Yes") {
                self.performSegueWithIdentifier("goto_yesmigrainetoday", sender: self)
                return
            } else {
                return
            }
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
