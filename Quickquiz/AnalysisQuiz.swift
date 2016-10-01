//
//  AnalysisQuiz.swift
//  Quickquiz
//
//  Created by MINGTIAN YANG on 7/15/16.
//  Copyright © 2016 MINGTIAN YANG. All rights reserved.
//

import Foundation
import SwiftyJSON

class AnalysisQuiz {
    func calculateScore(quizsample: JSON) -> Int {
        var rightCount = 0, wrongCount = 0, blankCount = 0, exceptionCount = 0
        if quizsample["results"]["right"].array != nil {
            rightCount = quizsample["results"]["right"].arrayValue.count
        }
        if quizsample["results"]["wrong"].array != nil {
            wrongCount = quizsample["results"]["wrong"].arrayValue.count
        }
        if quizsample["results"]["blank"].array != nil {
            blankCount = quizsample["results"]["blank"].arrayValue.count
        }
        if quizsample["results"]["exception"].array != nil {
            exceptionCount = quizsample["results"]["exception"].arrayValue.count
        }
        let totalQuestionCount = rightCount + wrongCount + blankCount + exceptionCount
        let rightPercentage: Double = Double(rightCount) / Double(totalQuestionCount)
        let score = Int(round(rightPercentage * 100))
        
        return score
    }

    func totalPercentage(quizsamples: JSON) -> [Double] {
        var totalRightCount:Int = 0
        var totalWrongCount:Int = 0
        var totalBlankCount:Int = 0
        
        for (_, quizsample) in quizsamples {
            
            if (quizsample["results"].dictionary != nil) {
                if (quizsample["results"]["right"].array != nil) {
                    totalRightCount += quizsample["results"]["right"].arrayValue.count
                }
                if (quizsample["results"]["wrong"].array != nil) {
                    totalWrongCount += quizsample["results"]["wrong"].arrayValue.count
                }
                if (quizsample["results"]["blank"].array != nil) {
                    totalBlankCount += quizsample["results"]["blank"].arrayValue.count
                }

            }
        }
        
        
        return [Double(totalRightCount),Double(totalWrongCount),Double(totalBlankCount)]

    }
    

}
