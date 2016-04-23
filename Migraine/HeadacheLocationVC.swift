//
//  HeadacheLocationVC.swift
//  Migraine
//
//  Created by Gohar Irfan on 2/20/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import UIKit

class HeadacheLocationVC: UIViewController {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var topLeft: UIImageView!
    @IBOutlet weak var topRight: UIImageView!
    @IBOutlet weak var bottomLeft: UIImageView!
    @IBOutlet weak var bottomRight: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
//        topLeft.addGestureRecognizer(tapGestureRecognizer)
//        bottomLeft.addGestureRecognizer(tapGestureRecognizer)
//        topRight.addGestureRecognizer(tapGestureRecognizer)
//        bottomRight.addGestureRecognizer(tapGestureRecognizer)
//        topLeft.frame = CGRectMake(0,0,container.frame.width*0.5,container.frame.height*0.5)
//        topRight.frame = CGRectMake(container.frame.width*0.5,0,container.frame.width*0.5,container.frame.height*0.5)
//        bottomLeft.frame = CGRectMake(0,container.frame.height*0.5,container.frame.width*0.5,container.frame.height*0.5)
//        bottomRight.frame = CGRectMake(container.frame.width*0.5,container.frame.height*0.5,container.frame.width*0.5,container.frame.height*0.5)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextActionButton(sender: UIButton) {
        self.performSegueWithIdentifier("goto_triggers", sender: self)
    }
    
    func imageTapped() {
        Logger.log("Image Tapped")
        topLeft.highlighted = true
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
