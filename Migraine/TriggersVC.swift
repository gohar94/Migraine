//
//  TriggersVC.swift
//  Migraine
//
//  Created by Gohar Irfan on 2/20/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import UIKit

class TriggersVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    struct Section {
        
        var heading : String
        var items : [String]
        var collapsed : Bool
        
        init(title: String, objects : [String]) {
            heading = title
            items = objects
            collapsed = false
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var other: UITextField!
    
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    var customs = [String]()
    var sectionsArray = [Section]()
    
    let sectionA = Section(title: "Every Day Stressors", objects: ["Emotional Stress", "Hunger", "Dehydration", "Gaps in between meals", "Sexual Activity", "Infections", "Too much sleep", "Lack of sleep", "Tiring Activity", "Exercise"])
    let sectionB = Section(title: "Foods", objects: ["Alcohol", "MSG", "Onions", "Citrus/Bananas", "Cheese", "Chocolate", "Nitrites", "Processed Foods", "Gluten", "Tyramine", "Dyes in food", "Artificial Sweetners", "Aspartame", "Saccharin", "Sucralose - Chlorinated sucrose"])
    let sectionC = Section(title: "Hormonal", objects: ["Menstruation", "Birth Control Pill"])
    let sectionD = Section(title: "Sensory Overload", objects: ["Light", "Noise", "Motion", "Perfumes"])
    let sectionE = Section(title: "Weather", objects: ["High Barometeric Pressure", "High Humidity", "High Temperature", "Wind", "Change in temperature", "Cold Temperature", "Lightning", "Drop in barometric pressure", "Flying"])
    let sectionF = Section(title: "Medication Rebound", objects: [])
    let sectionG = Section(title: "Polution", objects: ["Smoke", "Cigarette Smoke"])
    var sectionH = Section(title: "Custom", objects: [""])
    let customIndex = 7
    
    var selectedConditions = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        other.delegate = self
        
        sectionsArray.append(sectionA)
        sectionsArray.append(sectionB)
        sectionsArray.append(sectionC)
        sectionsArray.append(sectionD)
        sectionsArray.append(sectionE)
        sectionsArray.append(sectionF)
        sectionsArray.append(sectionG)
        sectionsArray.append(sectionH)
        
        var allSelectedTriggers = [String]()
        
        for section in sectionsArray {
            allSelectedTriggers.appendContentsOf(section.items)
        }
        
        let conditionsInPrefs = prefs.valueForKey("TRIGGERS") as? [String]
        if conditionsInPrefs != nil {
            selectedConditions = prefs.valueForKey("TRIGGERS") as! [String]
            for condition in conditionsInPrefs! {
                if (condition != "") {
                    if (!allSelectedTriggers.contains(condition)) {
                        sectionsArray[customIndex].items.append(condition)
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionsArray.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsArray[section].heading
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionsArray[section].items.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 43
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(sectionsArray[indexPath.section].collapsed == true){
            return 43
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 40))
        headerView.backgroundColor = UIColor(red: 152.0/255.0, green: 193.0/255.0, blue: 235.0/255.0, alpha: 1.0)
        headerView.tag = section
        
        let headerString = UILabel(frame: CGRect(x: 10, y: 10, width: tableView.frame.size.width-10, height: 30)) as UILabel
        headerString.text = sectionsArray[section].heading
        headerView.addSubview(headerString)
        
        let headerTapped = UITapGestureRecognizer (target: self, action:"sectionHeaderTapped:")
        headerView.addGestureRecognizer(headerTapped)
        
        return headerView
    }
    
    func sectionHeaderTapped(recognizer: UITapGestureRecognizer) {
        let indexPath : NSIndexPath = NSIndexPath(forRow: 0, inSection:(recognizer.view?.tag as Int!)!)
        if (indexPath.row == 0) {
            
            var collapsed = sectionsArray[indexPath.section].collapsed
            collapsed = !collapsed;
            
            sectionsArray[indexPath.section].collapsed = collapsed
            //reload specific section animated
            let range = NSMakeRange(indexPath.section, 1)
            let sectionToReload = NSIndexSet(indexesInRange: range)
            self.tableView .reloadSections(sectionToReload, withRowAnimation:UITableViewRowAnimation.Fade)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel!.text = sectionsArray[indexPath.section].items[indexPath.row]
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
            selectedConditions.append(sectionsArray[indexPath.section].items[indexPath.row])
            prefs.setObject(selectedConditions, forKey: "TRIGGERS")
            prefs.synchronize()
        } else {
            selectedRow.accessoryType = UITableViewCellAccessoryType.None
            let removeIndex = selectedConditions.indexOf(sectionsArray[indexPath.section].items[indexPath.row])
            if (removeIndex != nil) {
                selectedConditions.removeAtIndex(removeIndex!)
                prefs.setObject(selectedConditions, forKey: "TRIGGERS")
                prefs.synchronize()
            }
        }
    }
    
    func saveAddedItem() {
        if other.text != "" {
            let newItem = other.text
            if !selectedConditions.contains(newItem!) {
                sectionsArray[customIndex].items.append(newItem!)
                selectedConditions.append(newItem!)
                tableView.reloadData()
                prefs.setObject(selectedConditions, forKey: "TRIGGERS")
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
        self.performSegueWithIdentifier("goto_whathelpsmigraine", sender: self)
    }
    
    @IBAction func triggersInfoAction(sender: AnyObject) {
        let alert = UIAlertController(title: "What is a trigger?", message: "An environmental or personal change in daily pattern that is more likely to bring on a migraine within a few hours up to a day", preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
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
