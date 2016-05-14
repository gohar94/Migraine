//
//  ViewController.swift
//  Migraine
//
//  Created by Gohar Irfan on 2/14/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import UIKit

class OtherMedicalConditionsVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    var conditions = ["High Blood Pressure", "Diabetes", "Heart Attack/Coronary Artery Disease", "Cancer", "Stroke", "Irritable Bowel Syndrome", "Thyroid Problem", "Benign Prostatic Hypertrophy", "Eating Disorders", "Polycystic Ovarian Disease", "Obesity", "HIV", "Depression", "Anxiety", "Schizophrenia/Bipolar Disorder", "Attention Deficit Hyperactivity Disorder", "Attention Deficit Disorder", "Panic Disorder", "Food Allergies"]
    var selectedConditions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .Plain, target: self, action: #selector(OtherMedicalConditionsVC.skipTapped))
        
        let conditionsInPrefs = prefs.valueForKey("CONDITIONS") as? [String]
        if conditionsInPrefs != nil {
            selectedConditions = prefs.valueForKey("CONDITIONS") as! [String]
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
        sendDataToFirebase()
        self.performSegueWithIdentifier("goto_listofmedications", sender: self)
    }
    
    func skipTapped() {
        sendDataToFirebase()
        self.openViewControllerBasedOnIdentifier("DailySurveyVC")
        print("skip")
    }
}

