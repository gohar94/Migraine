//
//  AppDelegate.swift
//  Migraine
//
//  Created by Gohar Irfan on 2/14/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func handleNotification(notification: UILocalNotification) {
        if let userInfo = notification.userInfo {
            let type = userInfo["TYPE"] as! String
            if (type == "SLEEP") {
                print("Sleep notification received")
            } else if (type == "STRESS") {
                print("Stress notification received")
            } else {
                print("Some other notification type that is not supported appeared here")
            }
            // TODO this is not working properly, not taking to the desired VC
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let dailySurveryVCObject = storyboard.instantiateViewControllerWithIdentifier("DailySurveyVC") as? DailySurveyVC
            let navigationController = UINavigationController()
            navigationController.pushViewController(dailySurveryVCObject!, animated: true)
        }
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        Bugfender.enableAllWithToken("EmOWAcSZJnNcr4ninfSVd7PBdDZCPqXT")
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 140.0/255.0, green: 178.0/255.0, blue: 223.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.blackColor()
        
        // for local notifications
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        
        if let options = launchOptions {
            if let notification = options[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification {
                handleNotification(notification)
            }
        }
        
        return true
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        handleNotification(notification)
    }

    // TODO do we need this?
//    // enable offline for firebase
//    override init() {
//        super.init()
//        Firebase.defaultConfig().persistenceEnabled = true
//    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

