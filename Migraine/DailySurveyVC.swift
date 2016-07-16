//
//  DailySurveyVC.swift
//  Migraine
//
//  Created by Gohar Irfan on 4/8/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import UIKit

class DailySurveyVC: BaseViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var sleepDurationHours: UITextField!
    @IBOutlet weak var sleepDurationMinutes: UITextField!
    @IBOutlet weak var sleepQuality: UITextField!
    @IBOutlet weak var stress: UITextField!
    @IBOutlet weak var sleepDurationString: UIView!
    @IBOutlet weak var sleepQualityString: UIView!
    @IBOutlet weak var stressString: UIView!
    
    @IBOutlet weak var hadMigraine: UISwitch!
    @IBOutlet weak var sliderSleep: UISlider!
    @IBOutlet weak var sliderStress: UISlider!
    @IBOutlet weak var labelSleep: UILabel!
    @IBOutlet weak var labelStress: UILabel!
    
    let hourOptions = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24"]
//    let minuteOptions = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", "60"]
    let minuteOptions = ["0", "15", "30", "45"]
    let scaleOptions = ["1", "2", "3", "4", "5"]
    
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    enum PickerViewTag: Int {
        // Integer values will be implicitly supplied; you could optionally set your own values
        case PickerViewSleepDurationHours
        case PickerViewSleepDurationMinutes
        case PickerViewSleepQuality
        case PickerViewStress
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.addSlideMenuButton()
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
        // Do we want to show the persisted data or not? If no, remove the following lines
        let sleepDurationHoursInPrefs = prefs.valueForKey("SLEEPDURATIONHOURS") as? String
        if sleepDurationHoursInPrefs != nil {
            sleepDurationHours.text = prefs.valueForKey("SLEEPDURATIONHOURS") as? String
        }
        let sleepDurationMinutesInPrefs = prefs.valueForKey("SLEEPDURATIONMINUTES") as? String
        if sleepDurationMinutesInPrefs != nil {
            sleepDurationMinutes.text = prefs.valueForKey("SLEEPDURATIONMINUTES") as? String
        }
        let sleepQualtiyInPrefs = prefs.valueForKey("SLEEPQUALITY") as? Float
        if sleepQualtiyInPrefs != nil {
            sliderSleep.setValue(sleepQualtiyInPrefs!, animated: true)
            if (Int(sleepQualtiyInPrefs!) == 1) {
                labelSleep.text = "1) Sleep was awesome"
            } else if (Int(sleepQualtiyInPrefs!) == 2) {
                labelSleep.text = "2) Felt rested in the morning"
            } else if (Int(sleepQualtiyInPrefs!) == 3) {
                labelSleep.text = "3) Usual night's sleep"
            } else if (Int(sleepQualtiyInPrefs!) == 4) {
                labelSleep.text = "4) OK, could be better"
            } else {
                labelSleep.text = "5) Felt like crap in the morning"
            }
        }
        let stressInPrefs = prefs.valueForKey("STRESSLEVEL") as? Float
        if stressInPrefs != nil {
            sliderStress.setValue(stressInPrefs!, animated: true)
            if (Int(stressInPrefs!) == 1) {
                labelStress.text = "1) Relaxing day"
            } else if (Int(stressInPrefs!) == 2) {
                labelStress.text = "2) Usual day"
            } else if (Int(stressInPrefs!) == 3){
                labelStress.text = "3) Somewhat stressful"
            } else if (Int(stressInPrefs!) == 4) {
                labelStress.text = "4) Stressful"
            } else {
                labelStress.text = "5) Very stressful"
            }
        }
        let hadMigraineInPrefs = prefs.valueForKey("HADMIGRAINE") as? Bool
        if hadMigraineInPrefs != nil {
            hadMigraine.on = (prefs.valueForKey("HADMIGRAINE") as? Bool)!
        }
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
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(DailySurveyVC.doneSleepDurationHoursPressed(_:)))
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
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(DailySurveyVC.doneSleepDurationMinutesPressed(_:)))
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
    
    @IBAction func nextButtonAction(sender: UIButton) {
        print("Next")
        if (hadMigraine.on == false) {
            prefs.setValue(hadMigraine.on, forKey: "HADMIGRAINE")
            self.performSegueWithIdentifier("goto_nomigrainetoday", sender: self)
            return
        } else if (hadMigraine.on == true) {
            prefs.setValue(hadMigraine.on, forKey: "HADMIGRAINE")
            self.performSegueWithIdentifier("goto_yesmigrainetoday", sender: self)
            return
        } else {
            let alert = UIAlertController(title: "Error", message: "Before proceeding, please specify if you had a migraine today or not!", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
    }
    
    @IBAction func sleepInfoAction(sender: AnyObject) {
        let alert = UIAlertController(title: "Sleep Scale", message: "\n 1) Oh my God, last night's sleep was awesome \n \n 2) Felt rested in the morning \n \n 3) Usual night's sleep \n \n 4) OK but could have been better \n \n 5) Felt like crap in the morning", preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
        return
    }
    
    @IBAction func stressInfoAction(sender: AnyObject) {
        let alert = UIAlertController(title: "Stress Scale", message: "\n 1) Relaxing day \n \n 2) Usual day \n \n 3) Somewhat stressful \n \n 4) Stressful \n \n 5) Very stressful", preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
        return
    }

    @IBAction func stressSliderAction(sender: UISlider) {
        let currentValue = Int(sender.value)
        if (currentValue == 1) {
            labelStress.text = "1) Relaxing day"
        } else if (currentValue == 2) {
            labelStress.text = "2) Usual day"
        } else if (currentValue == 3){
            labelStress.text = "3) Somewhat stressful"
        } else if (currentValue == 4) {
            labelStress.text = "4) Stressful"
        } else {
            labelStress.text = "5) Very stressful"
        }
        prefs.setValue(currentValue, forKey: "STRESSLEVEL")
        prefs.synchronize()
    }
    
    @IBAction func sleepSliderAction(sender: UISlider) {
        let currentValue = Int(sender.value)
        if (currentValue == 1) {
            labelSleep.text = "1) Sleep was awesome"
        } else if (currentValue == 2) {
            labelSleep.text = "2) Felt rested in the morning"
        } else if (currentValue == 3) {
            labelSleep.text = "3) Usual night's sleep"
        } else if (currentValue == 4) {
            labelSleep.text = "4) OK, could be better"
        } else {
            labelSleep.text = "5) Felt like crap in the morning"
        }
        prefs.setValue(currentValue, forKey: "SLEEPQUALITY")
        prefs.synchronize()

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
