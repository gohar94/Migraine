//
//  MissingEndTimeVC.swift
//  Migraine
//
//  Created by Gohar Irfan on 7/17/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import UIKit

class MissingEndTimeVC: UIViewController {

    @IBOutlet weak var endDateTime: UITextField!
    @IBOutlet weak var migraineStarted: UILabel!
    @IBOutlet weak var migraineDuration: UILabel!
    @IBOutlet weak var boldText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let startDateTime = prefs.valueForKey("MISSINGMIGRAINESTART") as? String
        if startDateTime != nil {
            if startDateTime != "" {
                migraineStarted.text = "Migraine Started on " + startDateTime!
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
                dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
                let startDateTimeTemp = dateFormatter.dateFromString(startDateTime!)!
                let date = NSDate()
                let dif = datesOffset(startDateTimeTemp, date2: date)
                migraineDuration.text = "Duration of migraine is " + dif
                return
            }
        }
        
        // this code only executes when the above does not return
        boldText.text = "Your don't have any missing migraine End Time!"
        migraineDuration.hidden = true
        endDateTime.enabled = false
        endDateTime.hidden = true
        migraineStarted.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func datePickerMigraineEndValueChanged(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
        let selectedDateStr = dateFormatter.stringFromDate(sender.date)
        print(selectedDateStr)
        endDateTime.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func doneMigraineEndButtonPressed(sender: UIButton) {
        endDateTime.resignFirstResponder() // To resign the inputView on clicking done.
        prefs.setValue(endDateTime.text, forKey: "MIGRAINEENDTEMP") // this is the missing entry that will be updated
        prefs.synchronize()
    }

    @IBAction func startEndDateTimeAction(sender: UITextField) {
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
        doneButton.addTarget(self, action: #selector(YesMigraineTodayVC.doneMigraineEndButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside) // set button click event
        sender.inputView = inputView
        datePickerView.addTarget(self, action: #selector(YesMigraineTodayVC.datePickerMigraineEndValueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        datePickerMigraineEndValueChanged(datePickerView) // Set the date on start.
    }
    
    @IBAction func nextActionButton(sender: UIButton) {
        let endDateTimeTemp = prefs.valueForKey("MIGRAINEENDTEMP") as? String
        if endDateTimeTemp != nil {
            if endDateTimeTemp != "" {
                let startDateTime = prefs.valueForKey("MISSINGMIGRAINESTART") as? String
                if startDateTime != nil {
                    if startDateTime != "" {
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
                        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
                        let startDateTimeTemp = dateFormatter.dateFromString(startDateTime!)!
                        let endDateTimeTemp2 = dateFormatter.dateFromString(endDateTimeTemp!)!
                        if startDateTimeTemp.compare(endDateTimeTemp2) == NSComparisonResult.OrderedDescending {
                            // start is greater
                            let alert = UIAlertController(title: "Error", message: "Migraine End Time can not be before the Start Time. Please try again!", preferredStyle: .Alert)
                            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                            alert.addAction(action)
                            self.presentViewController(alert, animated: true, completion: nil)
                            return
                        }
                    }
                }
                sendMissingEndDateToFirebase(endDateTimeTemp!)
            }
        }
        let alert = UIAlertController(title: "Success", message: "Missing Migraine End Time updated successfully!", preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default) {
            UIAlertAction in
            self.performSegueWithIdentifier("goto_welcomefrommissingenddate", sender: self)
        }
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
