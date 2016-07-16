//
//  WhatHelpsMigraineVC.swift
//  Migraine
//
//  Created by Gohar Irfan on 2/20/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import UIKit

class WhatHelpsMigraineVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var other: UITextField!
    
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    var conditions = [String]()
    var selectedConditions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        other.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .Plain, target: self, action: #selector(WhatHelpsMigraineVC.skipTapped))
        
        let conditionsInPrefs = prefs.valueForKey("HELPMIGRAINE") as? [String]
        if conditionsInPrefs != nil {
            selectedConditions = prefs.valueForKey("HELPMIGRAINE") as! [String]
        }
        conditions = HELP_MIGRAINE
        for item in selectedConditions {
            if (!HELP_MIGRAINE.contains(item)) {
                conditions.append(item)
            }
            print(item)
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
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if selectedConditions.contains((cell.textLabel?.text)!) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
//            cell.tintColor = UIColor(red: 152.0/255.0, green: 193.0/255.0, blue: 235.0/255.0, alpha: 1.0)
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedRow = tableView.cellForRowAtIndexPath(indexPath)!
        if selectedRow.accessoryType == UITableViewCellAccessoryType.None {
            selectedRow.accessoryType = UITableViewCellAccessoryType.Checkmark
//            selectedRow.tintColor = UIColor(red: 152.0/255.0, green: 193.0/255.0, blue: 235.0/255.0, alpha: 1.0)
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
            }
        }
    }
    
    func saveAddedItem() {
        if other.text != "" {
            let newItem = other.text
            if (!selectedConditions.contains(newItem!)) {
                conditions.append(newItem!)
                selectedConditions.append(newItem!)
                tableView.reloadData()
                prefs.setObject(selectedConditions, forKey: "HELPMIGRAINE")
                prefs.synchronize()
            } else {
                let alert = UIAlertController(title: "Error", message: "The item you tried to add is already selected!", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
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
    
    func skipTapped() {
        sendDataToFirebase()
        self.openViewControllerBasedOnIdentifier("DailySurveyVC")
        print("skip")
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
