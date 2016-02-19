//
//  ViewController.swift
//  Migraine
//
//  Created by Gohar Irfan on 2/14/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import UIKit

class OtherMedicalConditionsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    var conditions = ["HTN", "DM", "MI, Heart Disease", "Cancer", "Stroke", "COPD/Emphysema", "Thyroid Problem", "BPH", "STDs", "Eating Disorders", "PCOS", "Obesity", "HIV", "Mental Disorders/Depression/Anxiety/Bipolar"]
    var selectedConditions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let conditionsInPrefs = prefs.valueForKey("CONDITIONS") as? [String]
        if conditionsInPrefs != nil {
            selectedConditions = prefs.valueForKey("CONDITIONS") as! [String]
        }
//        TODO need to show tick marks on previously stored conditions
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedRow = tableView.cellForRowAtIndexPath(indexPath)!
        if selectedRow.accessoryType == UITableViewCellAccessoryType.None {
            selectedRow.accessoryType = UITableViewCellAccessoryType.Checkmark
            selectedRow.tintColor = UIColor(red: 152.0/255.0, green: 193.0/255.0, blue: 235.0/255.0, alpha: 1.0)
            selectedConditions.append(conditions[indexPath.row])
            prefs.setObject(selectedConditions, forKey: "CONDITIONS")
            prefs.synchronize()
        } else {
            selectedRow.accessoryType = UITableViewCellAccessoryType.None
            let removeIndex = selectedConditions.indexOf(conditions[indexPath.row])
            if (removeIndex != nil) {
                selectedConditions.removeAtIndex(removeIndex!)
                prefs.setObject(selectedConditions, forKey: "CONDITIONS")
                prefs.synchronize()
            }
        }
    }

    @IBAction func nextAction(sender: UIButton) {
        // TODO save these conditions
        for condition in selectedConditions {
            print(condition)
        }
        self.performSegueWithIdentifier("goto_listofmedications", sender: self)
    }
}

