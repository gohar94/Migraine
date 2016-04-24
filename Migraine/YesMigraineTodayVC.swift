//
//  YesMigraineTodayVC.swift
//  Migraine
//
//  Created by Gohar Irfan on 4/16/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import UIKit

class YesMigraineTodayVC: UIViewController {

    @IBOutlet weak var dateTime: UITextField!

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let dateTimeInPrefs = prefs.valueForKey("MIGRAINESTART") as? String
        if dateTimeInPrefs != nil {
            dateTime.text = dateTimeInPrefs
        }
        let severityInPrefs = prefs.valueForKey("MIGRAINESEVERITY") as? Float
        if severityInPrefs != nil {
            slider.setValue(severityInPrefs!, animated: true)
            if (Int(severityInPrefs!) == 1) {
                label.text = "1) Mild - able to carry on with all of daily normal activities"
            } else if (Int(severityInPrefs!) == 2) {
                label.text = "2) Moderate - had to take something, stopped activity"
            } else {
                label.text = "3) Severe - thought about going to ER, went to bed early"
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startAction(sender: UITextField) {
        let inputView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 240))
        let datePickerView  : UIDatePicker = UIDatePicker(frame: CGRectMake(0, 40, 0, 0))
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        inputView.addSubview(datePickerView) // add date picker to UIView
        let doneButton = UIButton(frame: CGRectMake((self.view.frame.size.width/2) - (100/2), 0, 100, 50))
        doneButton.setTitle("Done", forState: UIControlState.Normal)
        doneButton.setTitle("Done", forState: UIControlState.Highlighted)
        doneButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        inputView.addSubview(doneButton) // add Button to UIView
        doneButton.addTarget(self, action: "doneMigraineButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside) // set button click event
        sender.inputView = inputView
        datePickerView.addTarget(self, action: Selector("datePickerMigraineValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        datePickerMigraineValueChanged(datePickerView) // Set the date on start.

    }
    
    func datePickerMigraineValueChanged(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
        let selectedDateStr = dateFormatter.stringFromDate(sender.date)
        print(selectedDateStr)
        dateTime.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func doneMigraineButtonPressed(sender: UIButton) {
        dateTime.resignFirstResponder() // To resign the inputView on clicking done.
        prefs.setValue(dateTime.text, forKey: "MIGRAINESTART")
        prefs.synchronize()
    }
     
    @IBAction func nextButtonAction(sender: UIButton) {
        self.performSegueWithIdentifier("goto_nomigraine2fromyesmigraine", sender: self)
        return
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        var currentValue = Int(sender.value)
        if (currentValue == 1) {
            label.text = "1) Mild - able to carry on with all of daily normal activities"
        } else if (currentValue == 2) {
            label.text = "2) Moderate - had to take something, stopped activity"
        } else {
            label.text = "3) Severe - thought about going to ER, went to bed early"
        }
        prefs.setValue(currentValue, forKey: "MIGRAINESEVERITY")
        prefs.synchronize()
    }
    
    @IBAction func severityInfoAction(sender: UIButton) {
        let alert = UIAlertController(title: "Migraine Severity Scale", message: "\n 1) Mild, able to carry on with all of daily normal activities \n \n 2) Moderate- had to take something, stopped activity \n \n 3) Severe- thought about going to ER, went to bed early", preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
        return
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
