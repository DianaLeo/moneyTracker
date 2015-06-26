//
//  PopupViewController.swift
//  moneyTracker
//
//  Created by User on 19/06/2015.
//  Copyright (c) 2015 User. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    var mthPicker: UIPickerView?
    var mthPickerDSyear:[Int] = []
    var bgWidth  = UIScreen.mainScreen().bounds.size.width
    var bgHeight = UIScreen.mainScreen().bounds.size.height

    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0...99 {
            mthPickerDSyear.append(selectedYear! - 99 + i)
        }
        mthPicker = UIPickerView(frame: CGRect(x: 0, y: -20, width: 150, height: bgHeight))
        mthPicker!.dataSource = self
        mthPicker!.delegate   = self
        mthPicker?.backgroundColor = UIColor.whiteColor()
        mthPicker!.selectRow(mthPickerDSyear.count - 1, inComponent: 0, animated: false)
        mthPicker!.selectRow(selectedMonth! - 1, inComponent: 1, animated: false)

        self.view.addSubview(mthPicker!)

    }
    
    //UIPickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
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
