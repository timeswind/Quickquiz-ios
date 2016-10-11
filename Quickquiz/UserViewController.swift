//
//  UserViewController.swift
//  Quickquiz
//
//  Created by MINGTIAN YANG on 7/14/16.
//  Copyright © 2016 MINGTIAN YANG. All rights reserved.
//

import UIKit
import SwiftyJSON
import Charts

class UserViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    var quizsample_list:JSON = nil
    var QuizPerformanceTrackLineChartView: QuizPerformanceTrackChartView!
    var TotalPercentagePieChartView: PieChartView!
    var role = ""
    
    var refreshControl:UIRefreshControl!
    
    @IBOutlet var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        refreshControl.addTarget(self, action: #selector(setUpViews), forControlEvents: .ValueChanged)
        collectionView!.addSubview(refreshControl)
        collectionView.setCollectionViewLayout(layout, animated: false)
        
        self.setUpViews()
        
    }
    
    func setUpViews() {
        role = GlobalVariables.sharedInstance.user_role
        
        if (role == "student") {
            self.setUpStudentView()
        }
    }
    
    func setUpStudentView() {
        self.navigationItem.title = "學生：\(GlobalVariables.sharedInstance.student_name)"
        collectionView.reloadData()
        stopRefresher()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    // make a cell for each cell index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("userViewCell", forIndexPath: indexPath)
        cell.subviews.forEach({ $0.removeFromSuperview() })
        if (role == "student") {
            if indexPath.row == 0 {
                if (NSUserDefaults.standardUserDefaults().objectForKey("quickquizs") != nil) {
                    quizsample_list = JSON.parse(NSUserDefaults.standardUserDefaults().objectForKey("quickquizs") as! String)
                    var quiztitles:[String] = []
                    var quizRightCountSets: [Double] = []
                    for (_, quizsample) in quizsample_list {
                        if (quizsample["quickquiz"]["finished"].boolValue) {
                            quiztitles.append(quizsample["quickquiz"]["title"].stringValue)
                            let quizScore = AnalysisQuiz().calculateScore(quizsample)
                            quizRightCountSets.append(Double(quizScore))
                        }
                    }
                    
                    QuizPerformanceTrackLineChartView = QuizPerformanceTrackChartView(frame: CGRectMake(16, 16, self.view.frame.width - 32, 268), dataPoints: quiztitles, values: quizRightCountSets)
                    let cardView = UIView(frame: CGRectMake(8,8,cell.frame.width - 16, cell.frame.height - 16))
                    cardView.addSubview(self.QuizPerformanceTrackLineChartView)
                    cardView.backgroundColor = UIColor.whiteColor()
                    cardView.layer.shadowOffset = CGSize(width: 0, height: 1)
                    cardView.layer.shadowOpacity = 0.2
                    cardView.layer.shadowRadius = 1
                    cardView.layer.cornerRadius = 3
                    cell.addSubview(cardView)
                }
                
            } else {
                let cardView = UIView(frame: CGRectMake(8,0,cell.frame.width - 16, cell.frame.height - 16))
                cardView.backgroundColor = UIColor.whiteColor()
                cardView.layer.shadowOffset = CGSize(width: 0, height: 1)
                cardView.layer.shadowOpacity = 0.2
                cardView.layer.shadowRadius = 1
                cardView.layer.cornerRadius = 3
                
                TotalPercentagePieChartView = PieChartView(frame: CGRectMake(8, 8, cell.frame.width - 16, cell.frame.height - 32))
                TotalPercentagePieChartView.descriptionText = ""
                let dataPoints = ["正確", "錯誤", "留空"]
                let totalPercentage = AnalysisQuiz().totalPercentage(quizsample_list)
                
                var dataEntries: [ChartDataEntry] = []
                
                for i in 0..<totalPercentage.count {
                    let dataEntry = ChartDataEntry(value: totalPercentage[i], xIndex: i)
                    dataEntries.append(dataEntry)
                }
                
                let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
                let colors: [UIColor] = [UIColor(hex: 0x4CAF50),UIColor(hex: 0xF44336), UIColor(hex:0xFFC107)]
                
                pieChartDataSet.colors = colors
                let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
                TotalPercentagePieChartView.data = pieChartData
                cardView.addSubview(TotalPercentagePieChartView)
                
                
                
                cell.addSubview(cardView)
            }
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Phone:
            return CGSize(width: screenWidth, height: 300);
        case .Pad:
            if (indexPath.row == 0) {
                return CGSize(width: screenWidth, height: 300);
            } else {
                return CGSize(width: screenWidth, height: 300);
            }
        default:
            return CGSize(width: screenWidth, height: 200);
        }
    }
    
    func stopRefresher() {
        refreshControl.endRefreshing()
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
