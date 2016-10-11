//
//  ViewController.swift
//  Quickquiz
//
//  Created by MINGTIAN YANG on 7/7/16.
//  Copyright © 2016 MINGTIAN YANG. All rights reserved.
//

import UIKit
import JWTDecode
import SwiftyJSON
import Alamofire

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!

    @IBOutlet var collectionView: UICollectionView!
    
    let reuseIdentifier = "quickquizCell"
    
    var quickquizs:JSON = nil
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.hidesBottomBarWhenPushed = true
        self.title = "我的小測"
        
        screenSize = UIScreen.mainScreen().bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth / 3, height: screenWidth / 3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.alwaysBounceVertical = true

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadData), forControlEvents: .ValueChanged)
        collectionView!.addSubview(refreshControl)
        collectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.validUser()
        if (!GlobalVariables.sharedInstance.quickquiz_list_load) {
            self.setUpQuickquizList()
        }
    }
    
    func loadData() {
        self.setUpQuickquizList()
    }
    
    func stopRefresher() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        refreshControl.endRefreshing()
    }
    
    func setUpQuickquizList() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let role = GlobalVariables.sharedInstance.user_role
        if (GlobalVariables.sharedInstance.user_valid) {
            ServerApi().getQuickquizList(role, lastQuizsampleId: "none") { result in
                if (result != JSON("FAIL")) {
                    print(result)
                    NSUserDefaults.standardUserDefaults().setObject(result.rawString(), forKey: "quickquizs")
                    
                    GlobalVariables.sharedInstance.quickquiz_list_load = true
                    self.quickquizs = result
                    self.stopRefresher()
                    self.collectionView.reloadData()
                }
            }
        }

    }
    
    func validUser() {
        if (Valid().tokenValid()) {
            print("token is valid")
            if (NSUserDefaults.standardUserDefaults().objectForKey("tokenBody") != nil) {
                let rawData = JSON(NSUserDefaults.standardUserDefaults().objectForKey("tokenBody")!)
                GlobalVariables.sharedInstance.initUser(rawData)
//                if (rawData["role"] == "student") {
//                    self.title = rawData["name"].stringValue
//                } else {
//                    self.title = rawData["name"].stringValue
//                }
                
            } else {
                let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
                do {
                    let decodedToken = try decode(token).body
                    NSUserDefaults.standardUserDefaults().setObject(decodedToken, forKey: "tokenBody")
                    GlobalVariables.sharedInstance.initUser(JSON(decodedToken))
                    
                } catch {
                    self.performSegueWithIdentifier("showLoginView", sender: self)
                }
            }
            //            print(NSUserDefaults.standardUserDefaults().objectForKey("token"))
            //            print(NSUserDefaults.standardUserDefaults().objectForKey("schoolid"))
            //            print(NSUserDefaults.standardUserDefaults().objectForKey("role"))
        } else {
            self.performSegueWithIdentifier("showLoginView", sender: self)
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.quickquizs.count
    }
    
    // make a cell for each cell index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("quickquizCell", forIndexPath: indexPath) as! QuickquizCollectionViewCell
        
        cell.cardWrapperView.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.cardWrapperView.layer.shadowOpacity = 0.2
        cell.cardWrapperView.layer.shadowRadius = 1
        cell.cardWrapperView.layer.cornerRadius = 3
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        
        let quickquiz = quickquizs[indexPath.row]
        
        if (quickquiz["quickquiz"]["title"].string != nil) {
            cell.titleLabel?.text = quickquiz["quickquiz"]["title"].stringValue
        }
        
        if (quickquiz["quickquiz"]["time"].int != nil) {
            cell.timeLabel?.text = "\(quickquiz["quickquiz"]["time"].intValue)分鐘"
            cell.timeLabel?.tintColor = UIColor.grayColor()
        }
        
        
        if ((quickquiz["quickquiz"]["finished"].bool) != nil && (quickquiz["quickquiz"]["finished"].bool!)) {
            if (quickquiz["quickquiz"]["finishTime"].string != nil) {
                cell.finishTimeLabel.hidden = false
                let finishTime = quickquiz["quickquiz"]["finishTime"].dateTime
                let convertedFinishTime = dateFormatter.stringFromDate(finishTime!)
                
                cell.finishTimeLabel?.text = "結束于\(convertedFinishTime)"
                cell.finishTimeLabel?.textColor = UIColor.grayColor()
            }
            cell.statusLabel?.text = "已結束"
            cell.statusLabel?.textColor = UIColor(red: CGFloat(0.0/255.0), green: CGFloat(122.0/255.0), blue: CGFloat(255.0/255.0), alpha: CGFloat(1.0))
        } else {
            cell.finishTimeLabel.hidden = true
            cell.statusLabel?.text = "小測進行中"
            cell.statusLabel?.textColor = UIColor(red: CGFloat(255.0/255.0), green: CGFloat(143.0/255.0), blue: CGFloat(0.0/255.0), alpha: CGFloat(1.0))
        }
        
        if (quickquiz["quickquiz"]["startTime"].string != nil) {
            let startTime = quickquiz["quickquiz"]["startTime"].dateTime

            let convertedStartTime = dateFormatter.stringFromDate(startTime!)
            
            cell.startTimeLabel?.text = "開始于\(convertedStartTime)"
            cell.startTimeLabel?.textColor = UIColor.grayColor()
        }
        
        if (quickquiz["results"].dictionary != nil && quickquiz["results"]["blank"].array != nil && quickquiz["results"]["right"].array != nil && quickquiz["results"]["wrong"].array != nil && quickquiz["results"]["exception"].array != nil) {
            let rightCount = quickquiz["results"]["right"].arrayValue.count
            let wrongCount = quickquiz["results"]["wrong"].arrayValue.count
            let blankCount = quickquiz["results"]["blank"].arrayValue.count
//            let exceptionCount = quickquiz["results"]["exception"].arrayValue.count

            let totalQuestionCount = rightCount + wrongCount + blankCount
            cell.scoreLabel?.text = "\(rightCount)/\(totalQuestionCount)"
            cell.scoreLabel?.textColor = UIColor.redColor()
            
        }
        

        
        return cell
    }
        
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        self.performSegueWithIdentifier("goWebView", sender: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Phone:
            return CGSize(width: screenWidth, height: 200);
        case .Pad:
            return CGSize(width: screenWidth/2, height: 200);
        default:
            return CGSize(width: screenWidth, height: 200);
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "goWebView") {
            
            let indexPath = sender as! NSIndexPath
            
            let webVc = segue.destinationViewController as! WebViewController
            webVc.hidesBottomBarWhenPushed = true
            webVc.requiredToken = true
            
            if (self.quickquizs[indexPath.row]["quickquiz"]["_id"].string != nil) {
                webVc.url = "\(GlobalVariables.sharedInstance.serverIp)/quickquiz?id=\(self.quickquizs[indexPath.row]["quickquiz"]["_id"].stringValue)"
            }

        } else if (segue.identifier == "goToScannerView") {
            let ScannerVc = segue.destinationViewController as! ScannerViewController
            ScannerVc.hidesBottomBarWhenPushed = true
        }
    }

}

