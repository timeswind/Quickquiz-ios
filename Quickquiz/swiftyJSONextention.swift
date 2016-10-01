//
//  swiftyJSONextention.swift
//  Quickquiz
//
//  Created by MINGTIAN YANG on 7/11/16.
//  Copyright © 2016 MINGTIAN YANG. All rights reserved.
//

import Foundation

import SwiftyJSON

extension JSON {
    
    public var date: NSDate? {
        get {
            switch self.type {
            case .String:
                return Formatter.jsonDateFormatter.dateFromString(self.object as! String)
            default:
                return nil
            }
        }
    }
    
    public var dateTime: NSDate? {
        get {
            switch self.type {
            case .String:
                return Formatter.jsonDateTimeFormatter.dateFromString(self.object as! String)
            default:
                return nil
            }
        }
    }
    
}