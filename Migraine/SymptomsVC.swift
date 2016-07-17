//
//  SymptomsVC.swift
//  Migraine
//
//  Created by Gohar Irfan on 2/20/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import UIKit

class SymptomsVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    var selectedConditions = [String]()
    var SYMPTOMS_TO_SHOW = SYMPTOMS
    @IBOutlet weak var other: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        other.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .Plain, target: self, action: #selector(SymptomsVC.skipTapped))
        
        SYMPTOMS_TO_SHOW = SYMPTOMS
        let conditionsInPrefs = prefs.valueForKey("SYMPTOMS") as? [String]
        if conditionsInPrefs != nil {
            selectedConditions = prefs.valueForKey("SYMPTOMS") as! [String]
            for condition in conditionsInPrefs! {
                if (condition != "") {
                    if (!SYMPTOMS_TO_SHOW.contains(condition)) {
                        SYMPTOMS_TO_SHOW.append(condition)
                        print(condition)
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SYMPTOMS_TO_SHOW.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel!.text = SYMPTOMS_TO_SHOW[indexPath.row]
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
            selectedConditions.append(SYMPTOMS_TO_SHOW[indexPath.row])
            prefs.setObject(selectedConditions, forKey: "SYMPTOMS")
            prefs.synchronize()
        } else {
            selectedRow.accessoryType = UITableViewCellAccessoryType.None
            let removeIndex = selectedConditions.indexOf(SYMPTOMS_TO_SHOW[indexPath.row])
            if (removeIndex != nil) {
                selectedConditions.removeAtIndex(removeIndex!)
                prefs.setObject(selectedConditions, forKey: "SYMPTOMS")
                prefs.synchronize()
            }
        }
    }
    
    // if you uncheck any of the custom entries then they will be deleted from the list the next time (this applies to triggers, other medical conditions etc. too)
    func saveAddedItem() {
        if other.text != "" {
            let newItem = other.text
            if !selectedConditions.contains(newItem!) && !SYMPTOMS_TO_SHOW.contains(newItem!) {
                selectedConditions.append(newItem!)
                SYMPTOMS_TO_SHOW.append(newItem!)
                tableView.reloadData()
                prefs.setObject(selectedConditions, forKey: "SYMPTOMS")
                prefs.synchronize()
            } else {
                let alert = UIAlertController(title: "Error", message: "The item you tried to add is already in the list!", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
                print("already added")
            }
            other.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        saveAddedItem()
        textField.resignFirstResponder()
        return true;
    }
    
    @IBAction func nextButtonAction(sender: UIButton) {
        sendDataToFirebase()
        self.performSegueWithIdentifier("goto_headachelocations", sender: self)
    }
    
    func skipTapped() {
        sendDataToFirebase()
        self.openViewControllerBasedOnIdentifier("DailySurveyVC")
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
