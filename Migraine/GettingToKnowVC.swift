//
//  ViewController6.swift
//  Migraine
//
//  Created by Gohar Irfan on 2/15/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import UIKit

class GettingToKnowVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var dateOfLMP: UITextField!
    @IBOutlet var dateOfNextPeriod: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var birthControl: UITextField!
    @IBOutlet weak var age: UITextField!
    
    let genderOptions = ["Female", "Male"]
    let birthControlOptions = ["A", "B", "C"]
    
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    enum PickerViewTag: Int {
        // Integer values will be implicitly supplied; you could optionally set your own values
        case PickerViewGender
        case PickerViewBirthControl
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .Plain, target: self, action: "skipTapped")
        
        let termsAgreed = prefs.valueForKey("TERMSAGREED") as? Bool
        if (termsAgreed != nil) {
            if (termsAgreed == false) {
                // it will never come here, just sanity stuff
                prefs.setBool(true, forKey: "TERMSAGREED")
                prefs.synchronize()
            }
        } else {
            prefs.setBool(true, forKey: "TERMSAGREED")
            prefs.synchronize()
        }

        prefs.setBool(true, forKey: "TERMSAGREED")
        prefs.synchronize()

        let birthControlInPrefs = prefs.valueForKey("BIRTHCONTROL") as? String
        if birthControlInPrefs != nil {
            birthControl.text = birthControlInPrefs
        }
        let ageInPrefs = prefs.valueForKey("AGE") as? String
        if ageInPrefs != nil {
            age.text = ageInPrefs
        }
        let genderInPrefs = prefs.valueForKey("GENDER") as? String
        if genderInPrefs != nil {
            gender.text = genderInPrefs
            if genderInPrefs?.lowercaseString == "female" {
                let dateOfLMPInPrefs = prefs.valueForKey("LMP") as? String
                if dateOfLMPInPrefs != nil {
                    dateOfLMP.text = dateOfLMPInPrefs
                }
                let dateOfNextPeriodInPrefs = prefs.valueForKey("NEXTPERIOD") as? String
                if dateOfNextPeriodInPrefs != nil {
                    dateOfNextPeriod.text = dateOfNextPeriodInPrefs
                }
            }
        }
    }

    @IBAction func genderAction(sender: UITextField) {
        let pickerView = UIPickerView()
        pickerView.tag = PickerViewTag.PickerViewGender.rawValue
        pickerView.delegate = self
        gender.inputView = pickerView
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.BlackTranslucent
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.backgroundColor = UIColor.blackColor()
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneGenderPressed:")
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.whiteColor()
        label.text = "Gender"
        label.textAlignment = NSTextAlignment.Center
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([textBtn,flexSpace,doneButton], animated: true)
        gender.inputAccessoryView = toolBar
        gender.text = genderOptions[0]
    }
    
    @IBAction func birthControlAction(sender: UITextField) {
        let pickerView = UIPickerView()
        pickerView.tag = PickerViewTag.PickerViewBirthControl.rawValue
        pickerView.delegate = self
        birthControl.inputView = pickerView
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.BlackTranslucent
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.backgroundColor = UIColor.blackColor()
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneBirthControlPressed:")
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.whiteColor()
        label.text = "Birth Control"
        label.textAlignment = NSTextAlignment.Center
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([textBtn,flexSpace,doneButton], animated: true)
        birthControl.inputAccessoryView = toolBar
        birthControl.text = birthControlOptions[0]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func doneGenderPressed(sender: UIBarButtonItem) {
        if gender.text?.lowercaseString == "female" {
            // Female specific inputs show 
            // TODO change birth control settings
            dateOfLMP.enabled = true
            dateOfNextPeriod.enabled = true
        } else {
            // Male specefic input show
            // TODO change birth control settings back here
            dateOfNextPeriod.text = ""
            dateOfLMP.text = ""
            dateOfLMP.enabled = false
            dateOfNextPeriod.enabled = false
        }
        prefs.setValue(gender.text, forKey: "GENDER")
        prefs.synchronize()
        gender.resignFirstResponder()
    }
    
    func doneBirthControlPressed(sender: UIBarButtonItem) {
//        TODO if birth control multiple then this needs to be an array
        birthControl.resignFirstResponder()
        prefs.setValue(birthControl.text, forKey: "BIRTHCONTROL")
        prefs.synchronize()
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let tag = PickerViewTag(rawValue: pickerView.tag) {
            switch tag {
            case .PickerViewGender:
                return genderOptions.count
            case .PickerViewBirthControl:
                return birthControlOptions.count
            }
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let tag = PickerViewTag(rawValue: pickerView.tag) {
            switch tag {
            case .PickerViewGender:
                return genderOptions[row]
            case .PickerViewBirthControl:
                return birthControlOptions[row]
            }
        }
        return birthControlOptions[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let tag = PickerViewTag(rawValue: pickerView.tag) {
            switch tag {
            case .PickerViewGender:
                gender.text = genderOptions[row]
            case .PickerViewBirthControl:
                birthControl.text = birthControlOptions[row]
            }
        }
    }
    
    @IBAction func dateOfLMPAction(sender: UITextField) {
        let inputView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 240))
        let datePickerView  : UIDatePicker = UIDatePicker(frame: CGRectMake(0, 40, 0, 0))
        datePickerView.datePickerMode = UIDatePickerMode.Date
        inputView.addSubview(datePickerView) // add date picker to UIView
        let doneButton = UIButton(frame: CGRectMake((self.view.frame.size.width/2) - (100/2), 0, 100, 50))
        doneButton.setTitle("Done", forState: UIControlState.Normal)
        doneButton.setTitle("Done", forState: UIControlState.Highlighted)
        doneButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        inputView.addSubview(doneButton) // add Button to UIView
        doneButton.addTarget(self, action: "doneLMPButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside) // set button click event
        sender.inputView = inputView
        datePickerView.addTarget(self, action: Selector("datePickerLMPValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        datePickerLMPValueChanged(datePickerView) // Set the date on start.
    }
    
    func datePickerLMPValueChanged(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        let selectedDateStr = dateFormatter.stringFromDate(sender.date)
        print(selectedDateStr)
        dateOfLMP.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func doneLMPButtonPressed(sender: UIButton) {
        dateOfLMP.resignFirstResponder() // To resign the inputView on clicking done.
        // TODO dateOfLMP here
        prefs.setValue(dateOfLMP.text, forKey: "LMP")
        prefs.synchronize()
    }
    
    @IBAction func dateOfNextPeriodAction(sender: UITextField) {
        let inputView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 240))
        let datePickerView  : UIDatePicker = UIDatePicker(frame: CGRectMake(0, 40, 0, 0))
        datePickerView.datePickerMode = UIDatePickerMode.Date
        inputView.addSubview(datePickerView) // add date picker to UIView
        let doneButton = UIButton(frame: CGRectMake((self.view.frame.size.width/2) - (100/2), 0, 100, 50))
        doneButton.setTitle("Done", forState: UIControlState.Normal)
        doneButton.setTitle("Done", forState: UIControlState.Highlighted)
        doneButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        inputView.addSubview(doneButton) // add Button to UIView
        doneButton.addTarget(self, action: "doneNextPeriodButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside) // set button click event
        sender.inputView = inputView
        datePickerView.addTarget(self, action: Selector("datePickerNextPeriodValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        datePickerNextPeriodValueChanged(datePickerView) // Set the date on start.
    }
    
    func datePickerNextPeriodValueChanged(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        let selectedDateStr = dateFormatter.stringFromDate(sender.date)
        print(selectedDateStr)
        dateOfNextPeriod.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func doneNextPeriodButtonPressed(sender: UIButton) {
        dateOfNextPeriod.resignFirstResponder() // To resign the inputView on clicking done.
        // TODO dateOfNextPeriod
        prefs.setValue(dateOfNextPeriod.text, forKey: "NEXTPERIOD")
        prefs.synchronize()
    }

    @IBAction func ageAction(sender: UITextField) {
        let str = String(age.text!)
        print(str)
        age.resignFirstResponder()
        if age.text != "" {
            prefs.setValue(age.text, forKey: "AGE")
            prefs.synchronize()
        }
    }
    
    @IBAction func nextAction(sender: UIButton) {
//        TODO pass on data to next section
        prefs.setValue(age.text, forKey: "AGE")
        prefs.setValue(gender.text, forKey: "GENDER")
        if gender.text?.lowercaseString == "female" {
            prefs.setValue(dateOfNextPeriod.text, forKey: "NEXTPERIOD")
            prefs.setValue(dateOfLMP.text, forKey: "LMP")
        }
        prefs.setValue(birthControl.text, forKey: "BIRTHCONTROL")
        prefs.synchronize()
        sendDataToFirebase()
        self.performSegueWithIdentifier("goto_othermedicalconditions", sender: self)
    }
    
    func skipTapped() {
        // TODO save, upload data and skip
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
