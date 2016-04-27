//
//  NoMigraineTodayVC.swift
//  Migraine
//
//  Created by Gohar Irfan on 4/8/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import UIKit

class NoMigraineTodayVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let migraineOptions = ["Yes", "No"]
    
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var migraine: UITextField!
    
    enum PickerViewTag: Int {
        // Integer values will be implicitly supplied; you could optionally set your own values
        case PickerViewMigraine
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let migraineInPrefs = prefs.valueForKey("LURKINGMIGRAINE") as? String
        if migraineInPrefs != nil {
            migraine.text = prefs.valueForKey("LURKINGMIGRAINE") as? String
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
            case .PickerViewMigraine:
                return migraineOptions.count
            }
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let tag = PickerViewTag(rawValue: pickerView.tag) {
            switch tag {
            case .PickerViewMigraine:
                return migraineOptions[row]
            }
        }
        return ""
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let tag = PickerViewTag(rawValue: pickerView.tag) {
            switch tag {
            case .PickerViewMigraine:
                migraine.text = migraineOptions[row]
            }
        }
    }
    
    @IBAction func migraineAction(sender: UITextField) {
        let pickerView = UIPickerView()
        pickerView.tag = PickerViewTag.PickerViewMigraine.rawValue
        pickerView.delegate = self
        migraine.inputView = pickerView
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.BlackTranslucent
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.backgroundColor = UIColor.blackColor()
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(NoMigraineTodayVC.doneMigrainePressed(_:)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.whiteColor()
        label.text = "Migraine"
        label.textAlignment = NSTextAlignment.Center
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([textBtn,flexSpace,doneButton], animated: true)
        migraine.inputAccessoryView = toolBar
        prefs.setObject(migraine.text, forKey: "LURKINGMIGRAINE")
        prefs.synchronize()
        migraine.text = migraineOptions[0]
    }
    
    func doneMigrainePressed(sender: UIBarButtonItem) {
        print(migraine.text)
        prefs.setObject(migraine.text, forKey: "LURKINGMIGRAINE")
        prefs.synchronize()
        migraine.resignFirstResponder()
    }
    
    @IBAction func nextButtonAction(sender: AnyObject) {
        self.performSegueWithIdentifier("goto_nomigraine2", sender: self)
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
