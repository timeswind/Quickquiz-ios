//
//  Formatter.swift
//  Quickquiz
//
//  Created by MINGTIAN YANG on 7/11/16.
//  Copyright © 2016 MINGTIAN YANG. All rights reserved.
//

import Foundation

class Formatter {
    
    private static var internalJsonDateFormatter: NSDateFormatter?
    private static var internalJsonDateTimeFormatter: NSDateFormatter?
    
    static var jsonDateFormatter: NSDateFormatter {
        if (internalJsonDateFormatter == nil) {
            internalJsonDateFormatter = NSDateFormatter()
            internalJsonDateFormatter!.dateFormat = "yyyy-MM-dd"
        }
        return internalJsonDateFormatter!
    }
    
    static var jsonDateTimeFormatter: NSDateFormatter {
        if (internalJsonDateTimeFormatter == nil) {
            internalJsonDateTimeFormatter = NSDateFormatter()
            internalJsonDateTimeFormatter!.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        }
        return internalJsonDateTimeFormatter!
    }
    
}