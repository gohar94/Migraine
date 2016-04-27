//
//  HeadacheDetailsVC.swift
//  Migraine
//
//  Created by Gohar Irfan on 2/20/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import UIKit

class HeadacheDetailsVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var duration: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    var conditions = ["One side of the head", "Both sides of the head", "Pulsating", "Stabbing", "Throbbing"]
    var selectedConditions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .Plain, target: self, action: #selector(HeadacheDetailsVC.skipTapped))
        
        let conditionsInPrefs = prefs.valueForKey("HEADACHECONDITIONS") as? [String]
        if conditionsInPrefs != nil {
            selectedConditions = prefs.valueForKey("HEADACHECONDITIONS") as! [String]
        }
        let durationInPrefs = prefs.valueForKey("HEADACHEDURATION") as? String
        if durationInPrefs != nil {
            duration.text = prefs.valueForKey("HEADACHEDURATION") as? String
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
            prefs.setObject(selectedConditions, forKey: "HEADACHECONDITIONS")
            prefs.synchronize()
        } else {
            selectedRow.accessoryType = UITableViewCellAccessoryType.None
            let removeIndex = selectedConditions.indexOf(conditions[indexPath.row])
            if (removeIndex != nil) {
                selectedConditions.removeAtIndex(removeIndex!)
                prefs.setObject(selectedConditions, forKey: "HEADACHECONDITIONS")
                prefs.synchronize()
            }
        }
    }
    
    @IBAction func doneButtonAction(sender: UIButton) {
        duration.resignFirstResponder()
        if duration.text != "" {
            prefs.setValue(duration.text, forKey: "HEADACHEDURATION")
            prefs.synchronize()
        }
    }
    
    @IBAction func nextButtonAction(sender: UIButton) {
        prefs.setValue(duration.text, forKey: "HEADACHEDURATION")
        prefs.setObject(selectedConditions, forKey: "HEADACHECONDITIONS")
        prefs.synchronize()
        if checkOneOrBoth() {
            sendDataToFirebase()
            self.performSegueWithIdentifier("goto_symptoms", sender: self)
        } else {
            let alert = UIAlertController(title: "Error", message: "Headache can either be on one side of the head or both sides of the head. Please choose one of these two options, not both!", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
    }
    
    func skipTapped() {
        if checkOneOrBoth() {
            sendDataToFirebase()
        }
        self.openViewControllerBasedOnIdentifier("DailySurveyVC")
        print("skip")
    }
    
    func checkOneOrBoth() -> Bool {
        // checks if only one of "both sides" or "one side" is selected
        let conditionsInPrefs = prefs.valueForKey("HEADACHECONDITIONS") as? [String]
        if conditionsInPrefs != nil {
            if (conditionsInPrefs!.contains("One side of the head") && conditionsInPrefs!.contains("Both sides of the head")) {
                return false
            }
        }
        return true
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
