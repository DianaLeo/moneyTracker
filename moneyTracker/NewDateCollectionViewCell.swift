//
//  NewDateCollectionViewCell.swift
//  moneyTracker
//
//  Created by User on 26/05/2015.
//  Copyright (c) 2015 User. All rights reserved.
//

import UIKit

class NewDateCollectionViewCell: NewCollectionViewCell {
    
    var datepicker: UIDatePicker?
    var rightLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var cellHeight = bgHeight * (1 - 0.15) - 100 * 3
        datepicker = UIDatePicker(frame: CGRect(x: 0, y: 54, width: bgWidth*0.8, height: 0.7*cellHeight))
        datepicker?.datePickerMode = UIDatePickerMode.Date
        datepicker?.hidden = true
        leftTextLabel?.text = "Date"
        rightLabel = UILabel(frame: CGRect(x: bgWidth - 400 - 50, y: 25, width: 400, height: 40))
        rightLabel?.textColor = UIColor(red: 0.53, green: 0.53, blue: 0.53, alpha: 1)
        rightLabel?.font      = UIFont.italicSystemFontOfSize(25)
        rightLabel?.textAlignment = NSTextAlignment.Right
        rightLabel?.hidden = true
        
        self.addSubview(datepicker!)
        self.addSubview(rightLabel!)

    }

    func datepickerValueChanged(){
        datepicker?.date
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}