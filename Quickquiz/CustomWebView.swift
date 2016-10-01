//
//  CustomWebView.swift
//  Quickquiz
//
//  Created by MINGTIAN YANG on 7/11/16.
//  Copyright © 2016 MINGTIAN YANG. All rights reserved.
//

import Foundation
import WebKit

class CustomWebView: WKWebView {
    override func loadRequest(request: NSURLRequest) -> WKNavigation? {
        guard let mutableRequest = request.mutableCopy() as? NSMutableURLRequest else {
            return super.loadRequest(request)
        }
        
        if NSUserDefaults.standardUserDefaults().objectForKey("token") != nil {
            let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
            mutableRequest.setValue(token, forHTTPHeaderField: "x-access-token")
        }
        
        return super.loadRequest(mutableRequest)
    }
}