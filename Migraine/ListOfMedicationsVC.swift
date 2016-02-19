//
//  ListOfMedicationsVC.swift
//  Migraine
//
//  Created by Gohar Irfan on 2/19/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import UIKit

class ListOfMedicationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addedMedicine: UITextField!
    
    var medication = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    @IBAction func addButtonAction(sender: UIButton) {
        let newItem = addedMedicine.text
        medication.append(newItem!)
        addedMedicine.text = ""
        addedMedicine.resignFirstResponder()
        tableView.reloadData()
    }

    @IBAction func nextButtonAction(sender: UIButton) {
        // TODO save mediciation
        for medicine in medication {
            print(medicine)
        }
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
