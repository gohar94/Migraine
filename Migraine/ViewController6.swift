//
//  ViewController6.swift
//  Migraine
//
//  Created by Gohar Irfan on 2/15/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import UIKit

class ViewController6: UIViewController {
    
    @IBOutlet var dateOfLMP: UITextField!
    @IBOutlet var dateOfNextPeriod: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func datePickerLMPValueChanged(sender:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        let selectedDateStr = dateFormatter.stringFromDate(sender.date)
        print(selectedDateStr)
        dateOfLMP.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func doneLMPButtonPressed(sender:UIButton)
    {
        dateOfLMP.resignFirstResponder() // To resign the inputView on clicking done.
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
    
    func datePickerNextPeriodValueChanged(sender:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        let selectedDateStr = dateFormatter.stringFromDate(sender.date)
        print(selectedDateStr)
        dateOfNextPeriod.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func doneNextPeriodButtonPressed(sender:UIButton)
    {
        dateOfNextPeriod.resignFirstResponder() // To resign the inputView on clicking done.
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
