//
//  QuizPerformanceTrackChartView.swift
//
//
//  Created by MINGTIAN YANG on 7/14/16.
//
//

import UIKit
import Charts

class QuizPerformanceTrackChartView: UIView {
    
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    convenience init (frame : CGRect, dataPoints: [String], values: [Double]) {
        self.init(frame:frame)
        
        let chartView = LineChartView(frame: CGRectMake(0, 0, frame.width - 16, frame.height - 16))
        chartView.xAxis.labelPosition = .Bottom
        chartView.descriptionText = ""
        chartView.noDataText = "無測驗記錄"
        chartView.drawGridBackgroundEnabled = false
        
        //            chartView.rightAxis.enabled = false
        //            chartView.leftAxis.enabled = false
        chartView.rightAxis.axisMaxValue = 100.0
        chartView.rightAxis.drawZeroLineEnabled = true
        chartView.rightAxis.axisLineWidth = 0.0
        chartView.rightAxis.labelTextColor = UIColor.grayColor()
        
        chartView.leftAxis.axisMaxValue = 100.0
        chartView.leftAxis.drawZeroLineEnabled = true
        chartView.leftAxis.axisLineWidth = 0.0
        chartView.leftAxis.labelTextColor = UIColor.grayColor()
        
        chartView.setScaleEnabled(false)
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(yVals:dataEntries, label: "測驗分數")
        chartDataSet.setCircleColor(UIColor(red: CGFloat(0.0/255.0), green: CGFloat(122.0/255.0), blue: CGFloat(255.0/255.0), alpha: CGFloat(1.0)))
        chartDataSet.setColor(UIColor(red: CGFloat(0.0/255.0), green: CGFloat(122.0/255.0), blue: CGFloat(255.0/255.0), alpha: CGFloat(1.0)))
        let chartData = LineChartData(xVals: dataPoints, dataSet: chartDataSet)
        chartView.data = chartData
        self.addSubview(chartView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
