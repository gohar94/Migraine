//
//  NoMigraineToday2VC.swift
//  Migraine
//
//  Created by Gohar Irfan on 4/24/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import UIKit

class NoMigraineToday2VC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    var selectedConditions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let conditionsInPrefs = prefs.valueForKey("SYMPTOMSTODAY") as? [String]
        if conditionsInPrefs != nil {
            selectedConditions = prefs.valueForKey("SYMPTOMSTODAY") as! [String]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SYMPTOMS.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel!.text = SYMPTOMS[indexPath.row]
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
            selectedConditions.append(SYMPTOMS[indexPath.row])
            prefs.setObject(selectedConditions, forKey: "SYMPTOMSTODAY")
            prefs.synchronize()
        } else {
            selectedRow.accessoryType = UITableViewCellAccessoryType.None
            let removeIndex = selectedConditions.indexOf(SYMPTOMS[indexPath.row])
            if (removeIndex != nil) {
                selectedConditions.removeAtIndex(removeIndex!)
                prefs.setObject(selectedConditions, forKey: "SYMPTOMSTODAY")
                prefs.synchronize()
            }
        }
    }
    
    @IBAction func nextButtonAction(sender: UIButton) {
        self.performSegueWithIdentifier("goto_nomigraine3", sender: self)
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
