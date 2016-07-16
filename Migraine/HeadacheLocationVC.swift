//
//  HeadacheLocationVC.swift
//  Migraine
//
//  Created by Gohar Irfan on 2/20/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import UIKit

class HeadacheLocationVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    var selectedConditions = [String]()
    
//    let locations = ["Right Frontal", "Right Temporal", "Right Occipital", "Right Behind the Eyes", "Right Base of Skull and Neck", "Left Frontal", "Left Temporal", "Left Occipital", "Left Behind the Eyes", "Left Base of Skull and Neck"]
    let locations = ["Frontal", "Temporal", "Occipital", "Behind the Eyes", "Base of Skull and Neck"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .Plain, target: self, action: #selector(HeadacheLocationVC.skipTapped))
        
        let conditionsInPrefs = prefs.valueForKey("HEADACHELOCATIONS") as? [String]
        if conditionsInPrefs != nil {
            selectedConditions = prefs.valueForKey("HEADACHELOCATIONS") as! [String]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel!.text = locations[indexPath.row]
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
            selectedConditions.append(locations[indexPath.row])
            prefs.setObject(selectedConditions, forKey: "HEADACHELOCATIONS")
            prefs.synchronize()
        } else {
            selectedRow.accessoryType = UITableViewCellAccessoryType.None
            let removeIndex = selectedConditions.indexOf(SYMPTOMS[indexPath.row])
            if (removeIndex != nil) {
                selectedConditions.removeAtIndex(removeIndex!)
                prefs.setObject(selectedConditions, forKey: "HEADACHELOCATIONS")
                prefs.synchronize()
            }
        }
    }
    
    @IBAction func nextActionButton(sender: UIButton) {
        var conditionsInPrefs = prefs.valueForKey("HEADACHELOCATIONS") as? [String]
        if conditionsInPrefs != nil {
            selectedConditions = prefs.valueForKey("HEADACHELOCATIONS") as! [String]
            if (conditionsInPrefs!.contains("Right Frontal") && conditionsInPrefs!.contains("Left Frontal")) {
                conditionsInPrefs!.removeAtIndex(conditionsInPrefs!.indexOf("Right Frontal")!)
                conditionsInPrefs!.removeAtIndex(conditionsInPrefs!.indexOf("Left Frontal")!)
                conditionsInPrefs!.append("Bilateral Frontal")
            }
            if (conditionsInPrefs!.contains("Right Temporal") && conditionsInPrefs!.contains("Left Temporal")) {
                conditionsInPrefs!.removeAtIndex(conditionsInPrefs!.indexOf("Right Temporal")!)
                conditionsInPrefs!.removeAtIndex(conditionsInPrefs!.indexOf("Left Temporal")!)
                conditionsInPrefs!.append("Bilateral Temporal")
            }
            if (conditionsInPrefs!.contains("Right Base of Skull and Neck") && conditionsInPrefs!.contains("Left Base of Skull and Neck")) {
                conditionsInPrefs!.removeAtIndex(conditionsInPrefs!.indexOf("Right Base of Skull and Neck")!)
                conditionsInPrefs!.removeAtIndex(conditionsInPrefs!.indexOf("Left Base of Skull and Neck")!)
                conditionsInPrefs!.append("Bilateral Base of Skull and Neck")
            }
            if (conditionsInPrefs!.contains("Right Behind the Eyes") && conditionsInPrefs!.contains("Left Behind the Eyes")) {
                conditionsInPrefs!.removeAtIndex(conditionsInPrefs!.indexOf("Right Behind the Eyes")!)
                conditionsInPrefs!.removeAtIndex(conditionsInPrefs!.indexOf("Left Behind the Eyes")!)
                conditionsInPrefs!.append("Bilateral Behind the Eyes")
            }
            prefs.setObject(conditionsInPrefs, forKey: "HEADACHELOCATIONS")
            prefs.synchronize()
        }
        sendDiaryToFirebase()
        self.performSegueWithIdentifier("goto_triggers", sender: self)
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
