//
//  WhatHelpsMigraineVC.swift
//  Migraine
//
//  Created by Gohar Irfan on 2/20/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import UIKit

class WhatHelpsMigraineVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var other: UITextField!
    
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    var conditions = [String]()
    var conditionsDefault = ["Sleep", "Yoga", "Exercise", "Medications", "Hydration", "Glasses to prevent glare"]
    var selectedConditions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        other.delegate = self
        
        let conditionsInPrefs = prefs.valueForKey("HELPMIGRAINE") as? [String]
        if conditionsInPrefs != nil {
            selectedConditions = prefs.valueForKey("HELPMIGRAINE") as! [String]
        }
        for item in selectedConditions {
            print(item)
        }
        // jugaar
        let conditionsAllInPrefs = prefs.valueForKey("HELPMIGRAINEALL") as? [String]
        if conditionsAllInPrefs != nil {
            conditions = prefs.valueForKey("HELPMIGRAINEALL") as! [String]
        } else {
            conditions = conditionsDefault
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conditions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel!.text = conditions[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if selectedConditions.contains((cell.textLabel?.text)!) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            cell.tintColor = UIColor(red: 152.0/255.0, green: 193.0/255.0, blue: 235.0/255.0, alpha: 1.0)
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedRow = tableView.cellForRowAtIndexPath(indexPath)!
        if selectedRow.accessoryType == UITableViewCellAccessoryType.None {
            selectedRow.accessoryType = UITableViewCellAccessoryType.Checkmark
            selectedRow.tintColor = UIColor(red: 152.0/255.0, green: 193.0/255.0, blue: 235.0/255.0, alpha: 1.0)
            selectedConditions.append(conditions[indexPath.row])
            prefs.setObject(selectedConditions, forKey: "HELPMIGRAINE")
            prefs.synchronize()
        } else {
            selectedRow.accessoryType = UITableViewCellAccessoryType.None
            let removeIndex = selectedConditions.indexOf(conditions[indexPath.row])
            if (removeIndex != nil) {
                selectedConditions.removeAtIndex(removeIndex!)
                prefs.setObject(selectedConditions, forKey: "HELPMIGRAINE")
                prefs.synchronize()
                if !conditionsDefault.contains(conditions[indexPath.row]) {
                    conditions.removeAtIndex(indexPath.row)
                    prefs.setObject(conditions, forKey: "HELPMIGRAINEALL")
                    prefs.synchronize()
                }
            }
        }
    }
    
    func saveAddedItem() {
        if other.text != "" {
            let newItem = other.text
            if !selectedConditions.contains(newItem!) {
                conditions.append(newItem!)
                selectedConditions.append(newItem!)
                tableView.reloadData()
                prefs.setObject(selectedConditions, forKey: "HELPMIGRAINE")
                prefs.setObject(conditions, forKey: "HELPMIGRAINEALL") // jugaar
                prefs.synchronize()
            } else {
                // TODO Alert that this item is already in the list
                print("already added")
            }
            other.text = ""
        }
    }
    
    @IBAction func doneButtonAction(sender: UIButton) {
        saveAddedItem()
        other.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        saveAddedItem()
        textField.resignFirstResponder()
        return true;
    }
    
    @IBAction func nextButtonAction(sender: UIButton) {
        sendDataToFirebase()
        self.performSegueWithIdentifier("goto_prompts", sender: self)
    }
    
    // TODO add other

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
