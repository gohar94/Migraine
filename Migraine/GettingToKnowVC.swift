//
//  ViewController6.swift
//  Migraine
//
//  Created by Gohar Irfan on 2/15/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import UIKit

class GettingToKnowVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet var dateOfLMP: UITextField!
    @IBOutlet var dateOfNextPeriod: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var birthControl: UITextField!
    @IBOutlet weak var age: UITextField!
    
    let genderOptions = ["Female", "Male"]
    let birthControlOptions = ["A", "B", "C"]
    
    enum PickerViewTag: Int {
        // Integer values will be implicitly supplied; you could optionally set your own values
        case PickerViewGender
        case PickerViewBirthControl
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        gender.resignFirstResponder()
    }
    
    func doneBirthControlPressed(sender: UIBarButtonItem) {
        birthControl.resignFirstResponder()
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
        return genderOptions.count
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
    }

    @IBAction func ageAction(sender: UITextField) {
        let str = String(age.text!)
        print(str)
        age.resignFirstResponder()
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
