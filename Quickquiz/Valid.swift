//
//  Login.swift
//  Quickquiz
//
//  Created by MINGTIAN YANG on 7/7/16.
//  Copyright © 2016 MINGTIAN YANG. All rights reserved.
//

import Foundation
import JWTDecode
import SwiftyJSON

class Login {
    
    public func tokenValid() -> Bool {
        let isLogin = NSUserDefaults.standardUserDefaults().objectForKey("isLogin")
        if (isLogin != nil && isLogin as! Bool == true) {
            if (NSUserDefaults.standardUserDefaults().objectForKey("token") != nil) {
                let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
                //                let role = NSUserDefaults.standardUserDefaults().objectForKey("role") as! String
                
                do {
                    let expireAt = try decode(token).expiresAt
                    let currentDate = NSDate()
                    
                    if expireAt!.compare(currentDate) == NSComparisonResult.OrderedDescending {
                        return true
                    } else {
                        return false
                    }
                    
                } catch {
                    print("Failed to decode JWT: \(error)")
                }
            } else {
                return false
            }
            
        } else {
            return false
        }
    }
    
    
    
}