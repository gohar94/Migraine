//
//  PromptsVC.swift
//  Migraine
//
//  Created by Gohar Irfan on 3/2/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import UIKit

class PromptsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var numberTableView: UITableView!
    @IBOutlet var sleepTime: UITextField!
    @IBOutlet var stressTime: UITextField!
    @IBOutlet var headacheTime: UITextField!
    
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    var numbers = ["1", "2"]
    var selectedNumber = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let numbersInPrefs = prefs.valueForKey("NUMBERPROMPTS") as? String
        if numbersInPrefs != nil {
            selectedNumber = prefs.valueForKey("NUMBERPROMPTS") as! String
        } else {
            // default number of prompts = 2
            selectedNumber = "2"
            prefs.setObject(selectedNumber, forKey: "NUMBERPROMPTS")
        }
        print(selectedNumber)
        let sleepInPrefs = prefs.valueForKey("SLEEPPROMPT") as? String
        if sleepInPrefs != nil {
            sleepTime.text = sleepInPrefs
        }
        let stressInPrefs = prefs.valueForKey("STRESSPROMPT") as? String
        if stressInPrefs != nil {
            stressTime.text = stressInPrefs
        }
        let headacheInPrefs = prefs.valueForKey("HEADACHEPROMPT") as? String
        if headacheInPrefs != nil {
            headacheTime.text = headacheInPrefs
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
    }
    
    func doneSleepButtonPressed(sender: UIButton) {
        sleepTime.resignFirstResponder() // To resign the inputView on clicking done.
        prefs.setValue(sleepTime.text, forKey: "SLEEPPROMPT")
        prefs.synchronize()
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
        datePickerSleepValueChanged(datePickerView) // Set the date on start.
    }
    
    func datePickerStressValueChanged(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        let selectedDateStr = dateFormatter.stringFromDate(sender.date)
        print(selectedDateStr)
        stressTime.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func doneStressButtonPressed(sender: UIButton) {
        stressTime.resignFirstResponder() // To resign the inputView on clicking done.
        prefs.setValue(stressTime.text, forKey: "STRESSPROMPT")
        prefs.synchronize()
        // TODO remove previous notification for stress if any
            }
    
    @IBAction func headacheAction(sender: UITextField) {
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
        doneButton.addTarget(self, action: "doneHeadacheButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside) // set button click event
        sender.inputView = inputView
        datePickerView.addTarget(self, action: Selector("datePickerHeadacheValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        datePickerSleepValueChanged(datePickerView) // Set the date on start.

    }
    
    func datePickerHeadacheValueChanged(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        let selectedDateStr = dateFormatter.stringFromDate(sender.date)
        print(selectedDateStr)
        headacheTime.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func doneHeadacheButtonPressed(sender: UIButton) {
        headacheTime.resignFirstResponder() // To resign the inputView on clicking done.
        prefs.setValue(headacheTime.text, forKey: "HEADACHEPROMPT")
        prefs.synchronize()
    }
    
    @IBAction func nextButtonAction(sender: UIButton) {
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