//
//  BaseService.swift
//  Migraine
//
//  Created by Gohar Irfan on 4/8/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import Foundation
import Firebase

let BASE_URL = "https://migraine-app.firebaseio.com"
let FIREBASE_REF = Firebase(url: BASE_URL)
var CURRENT_USER: Firebase
{
    let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
    let currentUser = Firebase(url: "\(FIREBASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)
    return currentUser!
}