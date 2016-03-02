//
//  ListOfMedicationsVC.swift
//  Migraine
//
//  Created by Gohar Irfan on 2/19/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import UIKit

class ListOfMedicationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addedMedicine: UITextField!
    
    var medication = [String]()
    
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addedMedicine.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .Plain, target: self, action: "skipTapped")
        
        let medicationsInPrefs = prefs.valueForKey("MEDICATION") as? [String]
        if medicationsInPrefs != nil {
            medication = prefs.valueForKey("MEDICATION") as! [String]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medication.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel!.text = medication[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let deletedRow:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        if editingStyle == UITableViewCellEditingStyle.Delete {
            medication.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            deletedRow.accessoryType = UITableViewCellAccessoryType.None
            prefs.setObject(medication, forKey: "MEDICATION")
            prefs.synchronize()
        }
    }
    
    func saveAddedItem() {
        if addedMedicine.text != "" {
            let newItem = addedMedicine.text
            if !medication.contains(newItem!) {
                medication.append(newItem!)
                tableView.reloadData()
                prefs.setObject(medication, forKey: "MEDICATION")
                prefs.synchronize()
            } else {
                // TODO Alert that this item is already in the list
                print("already added")
            }
            addedMedicine.text = ""
        }
    }
    
    @IBAction func addButtonAction(sender: UIButton) {
        saveAddedItem()
        addedMedicine.resignFirstResponder()
    }

    @IBAction func nextButtonAction(sender: UIButton) {
        // TODO save mediciation and update on server
        for medicine in medication {
            print(medicine)
        }
        self.performSegueWithIdentifier("goto_headachedetails", sender: self)
    }
    
    func skipTapped() {
        // TODO save, upload data and skip
        print("skip")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        saveAddedItem()
        textField.resignFirstResponder()
        return true;
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
