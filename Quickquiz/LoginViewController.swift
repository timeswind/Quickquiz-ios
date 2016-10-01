//
//  LoginViewController.swift
//  Quickquiz
//
//  Created by MINGTIAN YANG on 7/10/16.
//  Copyright © 2016 MINGTIAN YANG. All rights reserved.
//

import UIKit

import UIKit
import Alamofire
import SwiftyJSON
import JWTDecode

class LoginViewController: UIViewController {
    
    var role:String = "teacher"
    
    @IBOutlet var switchRoleButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet var accountTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var warnMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountTextField.placeholder = "教師郵箱"
        passwordTextField.placeholder = "密碼"
        passwordTextField.secureTextEntry = true
        switchRoleButton.setTitle("切換至學生登入", forState: .Normal)
        loginButton.setTitle("登入", forState: .Normal)
        warnMessage.hidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func switchRole(sender: AnyObject) {
        if (role == "teacher") {
            role = "student"
            accountTextField.placeholder = "學號"
            switchRoleButton.setTitle("切換至教師登入", forState: .Normal)
            
        } else {
            role = "teacher"
            accountTextField.placeholder = "教師郵箱"
            switchRoleButton.setTitle("切換至學生登入", forState: .Normal)
        }
    }
    
    @IBAction func login(sender: AnyObject) {
        if (role == "teacher") {
            
            if(isValidEmail(accountTextField.text!)) {
                warnMessage.hidden = true
                let request = NSMutableURLRequest(URL: NSURL(string: GlobalVariables.sharedInstance.serverIp + "/login")!)
                request.HTTPMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                
                let email = accountTextField.text!
                let password = passwordTextField.text!
                
                let postData = [ "email" : email, "password": password ]
                
                request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(postData, options: [])
                
                self.loginButton.enabled = false
                
                Alamofire.request(request)
                    .responseJSON { response in
                        
                        if let result = response.result.value {
                            
                            if result.isEqual("FAIL") {
                                
                                self.warnMessage.text = "登入失败"
                                self.warnMessage.hidden = false
                                self.passwordTextField.text = nil
                                self.loginButton.enabled = true
                                
                            } else {
                                
                                let json = JSON(result)
                                let token = json["token"].rawString()!
                                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isLogin")
                                NSUserDefaults.standardUserDefaults().setObject(token, forKey: "token")
                                NSUserDefaults.standardUserDefaults().setObject(email, forKey: "email")
                                NSUserDefaults.standardUserDefaults().setObject("teacher", forKey: "role")

                                do {
                                    let decodedToken = try decode(token).body
                                    NSUserDefaults.standardUserDefaults().setObject(decodedToken, forKey: "tokenBody")
                                    
                                } catch {
                                    print("Failed to decode JWT: \(error)")
                                }
                                
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }
                        }
                }
                
            } else {
                warnMessage.text = "郵箱格式不正確"
                warnMessage.hidden = false
            }
            
        } else {
            
            if(accountTextField.text!.characters.count == 8) {
                warnMessage.hidden = true
                
                let apiURL = (GlobalVariables.sharedInstance.serverIp + "/login/student")
//                let request = NSMutableURLRequest(URL: NSURL(string: GlobalVariables.sharedInstance.serverIp + "/login/student")!)
//                request.HTTPMethod = "POST"
//                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                
                let schoolid = accountTextField.text!
                let password = passwordTextField.text!
                
                let postData = [ "schoolid" : schoolid, "password": password ]
                
//                request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(postData, options: [])
                
                self.loginButton.enabled = false
                
                Alamofire.request(.POST, apiURL, parameters: postData)
                    .responseJSON { response in
                        print(response)
                        debugPrint(response)
                        if let result = response.result.value {
                            
                            print(result)
                            
                            if result.isEqual("student login fail") {
                                
                                self.warnMessage.text = "登入失败"
                                self.warnMessage.hidden = false
                                self.passwordTextField.text = nil
                                self.loginButton.enabled = true
                                
                            } else {
                                
                                let json = JSON(result)
                                let token = json["token"].string!
                                
                                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isLogin")
                                NSUserDefaults.standardUserDefaults().setObject(token, forKey: "token")
                                NSUserDefaults.standardUserDefaults().setObject(schoolid, forKey: "schoolid")
                                NSUserDefaults.standardUserDefaults().setObject("student", forKey: "role")
                                NSUserDefaults.standardUserDefaults().removeObjectForKey("quickquizs")
                                
                                do {
                                    let decodedToken = try decode(token).body
                                    NSUserDefaults.standardUserDefaults().setObject(decodedToken, forKey: "tokenBody")
                                    
                                } catch {
                                    print("Failed to decode JWT: \(error)")
                                }
                                
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }
                        }
                }
                
                
            } else {
                warnMessage.text = "學號格式不正確"
                warnMessage.hidden = false
            }
            
        }
        
        
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
