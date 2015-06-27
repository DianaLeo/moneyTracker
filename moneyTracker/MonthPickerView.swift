//
//  MonthPickerView.swift
//  moneyTracker
//
//  Created by User on 27/06/2015.
//  Copyright (c) 2015 User. All rights reserved.
//

import UIKit

class MonthPickerView: UIView,UIPickerViewDataSource,UIPickerViewDelegate {

    var mthPicker = UIPickerView()
    var mthPickerDSyear:[Int] = []
    var currentDate: NSString?
    var bgMask = UIButton()
    var bgMaskTop = UIButton()

    var mthHeight   = 60.0 as CGFloat
    var _naviRatio  = 0.15 as CGFloat
    var _naviHeight = CGFloat()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        _naviHeight = bgHeight * _naviRatio

        //picker数据源
        for i in 0...99 {
            mthPickerDSyear.append(selectedYear! - 99 + i)
        }
        
        mthPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 200, height: 370))
        mthPicker.dataSource = self
        mthPicker.delegate   = self
        mthPicker.backgroundColor = UIColor.whiteColor()
        mthPicker.selectRow(mthPickerDSyear.count - 1, inComponent: 0, animated: false)
        mthPicker.selectRow(selectedMonth! - 1, inComponent: 1, animated: false)
        
        bgMask = UIButton(frame: CGRect(x: 0, y: 0, width: bgWidth, height: bgHeight - _naviHeight - mthHeight))
        bgMask.backgroundColor = UIColor(white: 0, alpha: 0.4)
        
        bgMaskTop = UIButton(frame: CGRect(x: 0, y: -20, width: bgWidth, height: _naviHeight))
        bgMaskTop.backgroundColor = UIColor(white: 0, alpha: 0.4)
        
        addSubview(bgMask)
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
