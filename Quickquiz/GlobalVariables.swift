//
//  GlobalVariables.swift
//  Quickquiz
//
//  Created by MINGTIAN YANG on 7/7/16.
//  Copyright © 2016 MINGTIAN YANG. All rights reserved.
//
import SwiftyJSON

class GlobalVariables {
    
    static let sharedInstance = GlobalVariables()
    
    var serverIp:String = "https://www.pkms.hk"
//    var network_status = "disconnected"
    var currentUserRawData:JSON = nil
    
    var user_role = ""
    var user_valid = false
    
    var school_id:Int = 0
    var student_id:String = ""
    var student_name:String = ""
    
    var teacher_email:String = ""
    var teacher_name: String = ""
    var teacher_id:String = ""
    
    var quickquiz_list_load:Bool = false
    var first_time_userview = true
//    var token:String = ""
    
    func initUser(rawData:JSON) -> Void {
        self.currentUserRawData = rawData
        if (rawData["role"] == "student") {
            self.user_role = "student"
            self.user_valid = true
            self.school_id = rawData["schoolid"].intValue
            self.student_name = rawData["name"].stringValue
            self.student_id = rawData["student"].stringValue
        } else {
            self.user_role = "teacher"
            self.user_valid = true
            self.teacher_email = rawData["email"].stringValue
            self.teacher_name = rawData["name"].stringValue
            self.teacher_id = rawData["teacher"].stringValue
        }
    }
    
    func logout() -> Void {
        self.currentUserRawData = nil
        self.user_role = ""
        self.user_valid = false
        self.school_id = 0
        self.student_id = ""
        self.student_name = ""
        self.teacher_email = ""
        self.teacher_name = ""
        self.teacher_id = ""
        self.quickquiz_list_load = false
        self.first_time_userview = true
    }

}
