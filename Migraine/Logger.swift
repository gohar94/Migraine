//
//  Logger.swift
//  Migraine
//
//  Created by Gohar Irfan on 4/21/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import Foundation

public class Logger {
    static func log(logMessage: String, fileName: String = #file, lineName: Int = #line, columnName: Int = #column, functionName: String = #function) {
        let str = "File = \(fileName), Line = \(lineName), Column = \(columnName), Function = \(functionName) : \(logMessage)"
        print(str)
        BFLog(str)
    }
}