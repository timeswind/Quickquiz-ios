//
//  ServerApi.swift
//  Quickquiz
//
//  Created by MINGTIAN YANG on 7/10/16.
//  Copyright © 2016 MINGTIAN YANG. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import JWTDecode

class ServerApi {
    let server = GlobalVariables.sharedInstance.serverIp
    
    internal func refetchToken(role:String, password:String, completion:(Bool) -> ()) {
        print("REFETCH TOKEN")
        
        switch role {
        case "student":
            fetchStudentToken(password) {success in
                if success {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        default:
            fetchTeacherToken(password) {success in
                if success {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    internal func getQuickquizList(role: String, lastQuizsampleId: String, completion:(JSON) -> ()) {
        
        print("GET QUICKQUIZLIST")
        
        var apiURL = ""
        
        switch role {
        case "student":
            apiURL = "\(GlobalVariables.sharedInstance.serverIp)/api/manage-quickquiz/student/quickquizs"
        default:
            apiURL = "\(GlobalVariables.sharedInstance.serverIp)/api/manage-quickquiz/teacher/quickquizs"
        }
        
        if lastQuizsampleId != "none" {
            apiURL += lastQuizsampleId
        }
        
        print(apiURL)
        
        let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        let request = NSMutableURLRequest(URL: NSURL(string: apiURL)!)
        request.HTTPMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "x-access-token")
        
        Alamofire.request(request)
            .responseJSON { response in
                if let result = response.result.value {
                    completion(JSON(result))
                } else {
                    completion(JSON("FAIL"))
                }
        }

        
    }
    
    private func fetchStudentToken(password:String, completion:(Bool) -> ()) {
        let schoolid:String = NSUserDefaults.standardUserDefaults().stringForKey("schoolid")!
        
        let request = NSMutableURLRequest(URL: NSURL(string: server + "/login/student")!)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let postBodyData = ["schoolid": schoolid, "password": password]
        
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(postBodyData, options: [])
        
        Alamofire.request(request)
            .responseJSON { response in
                
                if let result = response.result.value {
                    
                    if result.isEqual("FAIL") {
                        
                        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isLogin")
                        completion(false)
                        
                        
                    } else {
                        
                        let json = JSON(result)
                        let token = json["token"].rawString()!
                        
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isLogin")
                        NSUserDefaults.standardUserDefaults().setObject(token, forKey: "token")
                        
                        do {
                            let decodedToken = try decode(token).body
                            NSUserDefaults.standardUserDefaults().setObject(decodedToken, forKey: "tokenBody")
                            
                        } catch {
                            print("Failed to decode JWT: \(error)")
                        }
                        
                        completion(true)
                        
                    }
                }
        }
    }
    
    private func fetchTeacherToken(password:String, completion:(Bool) -> ()) {
        let email:String = NSUserDefaults.standardUserDefaults().stringForKey("email")!
        
        let request = NSMutableURLRequest(URL: NSURL(string: server + "/login")!)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let postBodyData = ["email": email, "password": password]
        
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(postBodyData, options: [])
        
        Alamofire.request(request)
            .responseJSON { response in
                
                if let result = response.result.value {
                    
                    if result.isEqual("FAIL") {
                        
                        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isLogin")
                        completion(false)
                        
                        
                    } else {
                        
                        let json = JSON(result)
                        let token = json["token"].rawString()!
                        
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isLogin")
                        NSUserDefaults.standardUserDefaults().setObject(token, forKey: "token")
                        
                        do {
                            let decodedToken = try decode(token).body
                            NSUserDefaults.standardUserDefaults().setObject(decodedToken, forKey: "tokenBody")
                            
                        } catch {
                            print("Failed to decode JWT: \(error)")
                        }
                        
                        completion(true)
                        
                    }
                }
        }
    }
}
