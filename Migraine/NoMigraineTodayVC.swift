//
//  NoMigraineTodayVC.swift
//  Migraine
//
//  Created by Gohar Irfan on 4/8/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import UIKit

class NoMigraineTodayVC: UIViewController {
    
    let migraineOptions = ["Yes", "No"]
    
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var migraine: UISwitch!
    
    enum PickerViewTag: Int {
        // Integer values will be implicitly supplied; you could optionally set your own values
        case PickerViewMigraine
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let migraineInPrefs = prefs.valueForKey("LURKINGMIGRAINE") as? String // this should be bool in database now but since it was once a string, i am keeping it as a string for backward compatibility
        if migraineInPrefs != nil {
            let migraineLurkingStr = prefs.valueForKey("LURKINGMIGRAINE") as? String
            var migraineLurkingBool = false
            if migraineLurkingStr == "Yes" {
                migraineLurkingBool = true
            }
            migraine.on = migraineLurkingBool
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func nextButtonAction(sender: AnyObject) {
        var migraineLurkingStr = "No"
        if migraine.on == true {
            migraineLurkingStr = "Yes"
        }
        prefs.setValue(migraineLurkingStr, forKey: "LURKINGMIGRAINE")
        prefs.synchronize()
        self.performSegueWithIdentifier("goto_nomigraine2", sender: self)
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
