//
//  MonthSummaryView.swift
//  moneyTracker
//
//  Created by User on 26/06/2015.
//  Copyright (c) 2015 User. All rights reserved.
//

import UIKit

class MonthSummaryView: UIView,UIPickerViewDataSource,UIPickerViewDelegate {

    var mthBtn = UIButton()
    var mthBtnAngle = UIImageView()
    var mthLabExpense = UILabel()
    var mthLabIncome  = UILabel()
    var mthPicker = UIPickerView()
    var mthPickerShadow = UILabel()
    var mthPickerDSyear:[Int] = []
    var bgMask = UIButton()
    var bgMaskTop = UIButton()
    var currentDate: NSString?
    
    var mthHeight = 60.0 as CGFloat

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //picker数据源
        currentDate = NSDate().description as NSString
        selectedYear  = currentDate!.substringToIndex(4).toInt()!
        selectedMonth = currentDate!.substringWithRange(NSRange(location: 5, length: 2)).toInt()!
        for i in 0...99 {
            mthPickerDSyear.append(selectedYear! - 99 + i)
        }
        
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
        
        mthPicker = UIPickerView(frame: CGRect(x: 0, y: mthHeight, width: 200, height: bgHeight))
        mthPicker.dataSource = self
        mthPicker.delegate   = self
        mthPicker.backgroundColor = UIColor.whiteColor()
        mthPicker.hidden = true
        mthPicker.selectRow(mthPickerDSyear.count - 1, inComponent: 0, animated: false)
        mthPicker.selectRow(selectedMonth! - 1, inComponent: 1, animated: false)
        
        bgMask = UIButton(frame: CGRect(x: 0, y: mthHeight, width: bgWidth, height: bgHeight))
        bgMask.backgroundColor = UIColor(white: 0, alpha: 0.4)
        bgMask.hidden = true
        
        bgMaskTop = UIButton(frame: CGRect(x: bgWidth/3, y: 0, width: 2*bgWidth/3, height: mthHeight))
        bgMaskTop.backgroundColor = UIColor(white: 0, alpha: 0.4)
        bgMaskTop.hidden = true
        
        addSubview(mthBtn)
        addSubview(mthLabExpense)
        addSubview(mthLabIncome)
        addSubview(mthLine)
        addSubview(mthLine2)
        addSubview(bgMask)
        addSubview(bgMaskTop)
        addSubview(mthPicker)

    }

    //UIPickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        println("2 columns")
        
        return 2
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (component == 0){
            return mthPickerDSyear.count
        }else{
            return 12
        }
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if (component == 0){
            return "\(mthPickerDSyear[row])"
        }else{
            return "\(row + 1)"
        }
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (component == 0){
            selectedYear  = mthPickerDSyear[row]
        }else{
            selectedMonth = row + 1
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
