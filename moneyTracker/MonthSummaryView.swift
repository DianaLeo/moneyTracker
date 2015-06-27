//
//  MonthSummaryView.swift
//  moneyTracker
//
//  Created by User on 26/06/2015.
//  Copyright (c) 2015 User. All rights reserved.
//

import UIKit

class MonthSummaryView: UIView {

    var mthBtn = UIButton()
    var mthBtnAngle = UIImageView()
    var mthLabExpense = UILabel()
    var mthLabIncome  = UILabel()
    var bgMaskMid = UIButton()
    var flagPickerHidden = true
    var currentDate: NSString?
    
    var mthHeight = 60.0 as CGFloat

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //picker数据源
        currentDate = NSDate().description as NSString
        selectedYear  = currentDate!.substringToIndex(4).toInt()!
        selectedMonth = currentDate!.substringWithRange(NSRange(location: 5, length: 2)).toInt()!
        
        //月收支 mth
        mthBtn = UIButton(frame: CGRect(x: 0, y: 0, width: bgWidth/3, height: mthHeight))
        mthBtn.setTitle("\(selectedYear!)-\(selectedMonth!)", forState: UIControlState.Normal)
        mthBtn.backgroundColor = UIColor(red: 0.82, green: 0.43, blue: 0.37, alpha: 1)
        mthBtn.setBackgroundImage(UIImage(named: "btnMonthHighlighted"), forState: UIControlState.Highlighted)
        mthBtnAngle = UIImageView(frame: CGRect(x: bgWidth/3 - 29, y: mthHeight - 29, width: 29, height: 29))
        mthBtnAngle.image = UIImage(named: "btnMonth")
        mthBtn.addSubview(mthBtnAngle)
        
        mthLabExpense = UILabel(frame: CGRect(x: bgWidth/3, y: 0, width: bgWidth/3, height: mthHeight))
        mthLabExpense.backgroundColor = UIColor(red: 0.82, green: 0.43, blue: 0.37, alpha: 1)
        mthLabExpense.text = "Expense:\n\(BIExpense.monthSum(year: selectedYear!, month: selectedMonth!))"
        mthLabExpense.textAlignment = NSTextAlignment.Center
        mthLabExpense.textColor = UIColor.whiteColor()
        mthLabExpense.numberOfLines = 0
        
        mthLabIncome  = UILabel(frame: CGRect(x: bgWidth/3*2, y: 0, width: bgWidth/3, height: mthHeight))
        mthLabIncome.backgroundColor = UIColor(red: 0.82, green: 0.43, blue: 0.37, alpha: 1)
        mthLabIncome.text  = "Income:\n\(BIIncome.monthSum(year: selectedYear!, month: selectedMonth!))"
        mthLabIncome.textAlignment = NSTextAlignment.Center
        mthLabIncome.textColor = UIColor.whiteColor()
        mthLabIncome.numberOfLines = 0
        
        var mthLine   = UILabel(frame: CGRect(x: bgWidth/3, y: 0, width: 0.5, height: mthHeight))
        var mthLine2  = UILabel(frame: CGRect(x: bgWidth/3*2, y: 0, width: 0.5, height: mthHeight))
        mthLine.backgroundColor = UIColor.whiteColor()
        mthLine2.backgroundColor = UIColor.whiteColor()
        
        bgMaskMid = UIButton(frame: CGRect(x: bgWidth/3, y: 0, width: 2*bgWidth/3, height: mthHeight))
        bgMaskMid.backgroundColor = UIColor(white: 0, alpha: 0.4)
        bgMaskMid.hidden = true
        
        addSubview(mthBtn)
        addSubview(mthLabExpense)
        addSubview(mthLabIncome)
        addSubview(mthLine)
        addSubview(mthLine2)
        addSubview(bgMaskMid)
    }

    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
