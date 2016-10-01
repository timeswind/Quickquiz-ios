//
//  QuickquizCollectionViewCell.swift
//  Quickquiz
//
//  Created by MINGTIAN YANG on 7/11/16.
//  Copyright © 2016 MINGTIAN YANG. All rights reserved.
//

import UIKit
import SwiftyJSON

class QuickquizCollectionViewCell: UICollectionViewCell {    
    @IBOutlet var cardWrapperView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var startTimeLabel: UILabel!
    @IBOutlet var finishTimeLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!

//    func setUpView(quickquiz: JSON) {
//        let quizTitle = quickquiz["title"].stringValue
//        titleLabel?.text = quizTitle
//        
//    }
}
