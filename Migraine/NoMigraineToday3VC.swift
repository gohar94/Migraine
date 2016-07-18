//
//  NoMigraineToday3VC.swift
//  Migraine
//
//  Created by Gohar Irfan on 4/24/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import UIKit

class NoMigraineToday3VC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    var sectionsArray = [Section]()
    
    var sectionH = Section(title: "Custom", objects: [""])
    let customIndex = 7
    
    var selectedConditions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        sectionsArray.append(sectionA)
//        sectionsArray.append(sectionB)
//        sectionsArray.append(sectionC)
//        sectionsArray.append(sectionD)
//        sectionsArray.append(sectionE)
//        sectionsArray.append(sectionF)
//        sectionsArray.append(sectionG)
//        sectionsArray.append(sectionH)
        
        var sectionAToInclude = Section(title: "Everyday Stressors", objects: [])
        var sectionBToInclude = Section(title: "Foods", objects: [])
        var sectionCToInclude = Section(title: "Hormonal", objects: [])
        var sectionDToInclude = Section(title: "Sensory Overload", objects: [])
        var sectionEToInclude = Section(title: "Weather", objects: [])
        var sectionFToInclude = Section(title: "Pollution", objects: [])
        var sectionGToInclude = Section(title: "Other", objects: [])
        var sectionHToInclude = Section(title: "Custom", objects: [])
        
        var allSelectedTriggers = [String]()
        
        for section in sectionsArray {
            allSelectedTriggers.appendContentsOf(section.items)
        }
        
        let conditionsInPrefs = prefs.valueForKey("TRIGGERS") as? [String]
        if conditionsInPrefs != nil {
            selectedConditions = prefs.valueForKey("TRIGGERS") as! [String]
            for condition in conditionsInPrefs! {
                if (condition != "") {
//                    if (!allSelectedTriggers.contains(condition)) {
//                        sectionHToInclude.append(condition)
                    print(condition)
//                    }
                    // i'm sleepy!
                    var found = false
                    if (sectionA.items.contains(condition)) {
                        sectionAToInclude.items.append(condition)
                        found = true
                    }
                    if (sectionB.items.contains(condition)) {
                        sectionBToInclude.items.append(condition)
                        found = true
                    }
                    if (sectionC.items.contains(condition)) {
                        sectionCToInclude.items.append(condition)
                        found = true
                    }
                    if (sectionD.items.contains(condition)) {
                        sectionDToInclude.items.append(condition)
                        found = true
                    }
                    if (sectionE.items.contains(condition)) {
                        sectionEToInclude.items.append(condition)
                        found = true
                    }
                    if (sectionF.items.contains(condition)) {
                        sectionFToInclude.items.append(condition)
                        found = true
                    }
                    if (sectionG.items.contains(condition)) {
                        sectionGToInclude.items.append(condition)
                        found = true
                    }
                    if (!found) {
                        sectionHToInclude.items.append(condition)
                    }
                }
            }
            // okay, now i really need to sleep
            if (!sectionAToInclude.items.isEmpty) {
                sectionsArray.append(sectionAToInclude)
            }
            if (!sectionBToInclude.items.isEmpty) {
                sectionsArray.append(sectionBToInclude)
            }
            if (!sectionCToInclude.items.isEmpty) {
                sectionsArray.append(sectionCToInclude)
            }
            if (!sectionDToInclude.items.isEmpty) {
                sectionsArray.append(sectionDToInclude)
            }
            if (!sectionEToInclude.items.isEmpty) {
                sectionsArray.append(sectionEToInclude)
            }
            if (!sectionFToInclude.items.isEmpty) {
                sectionsArray.append(sectionFToInclude)
            }
            if (!sectionGToInclude.items.isEmpty) {
                sectionsArray.append(sectionGToInclude)
            }
            if (!sectionHToInclude.items.isEmpty) {
                sectionsArray.append(sectionHToInclude)
            }
        }
        selectedConditions.removeAll() // always start from scratch for daily diary
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
        
        let headerTapped = UITapGestureRecognizer (target: self, action:#selector(NoMigraineToday3VC.sectionHeaderTapped(_:)))
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
            selectedConditions.append(sectionsArray[indexPath.section].items[indexPath.row])
            prefs.setObject(selectedConditions, forKey: "TRIGGERSTODAY")
            prefs.synchronize()
        } else {
            selectedRow.accessoryType = UITableViewCellAccessoryType.None
            let removeIndex = selectedConditions.indexOf(sectionsArray[indexPath.section].items[indexPath.row])
            if (removeIndex != nil) {
                selectedConditions.removeAtIndex(removeIndex!)
                prefs.setObject(selectedConditions, forKey: "TRIGGERSTODAY")
                prefs.synchronize()
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    @IBAction func nextButtonAction(sender: UIButton) {
        self.performSegueWithIdentifier("goto_nomigraine4", sender: self)
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
