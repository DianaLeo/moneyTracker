//
//  BIHomeViewController.swift
//  BillInfo
//
//  Created by User on 20/05/2015.
//  Copyright (c) 2015 Silversr. All rights reserved.
//

//屏幕高：bgHeight＝667;状态条高：naviY=20;默认导航栏高：naviHeight=44;
//我的导航栏高：_naviHeight=bgHeight*0.15;我的导航栏SubImage高：naviImageHeight=_naviHeight-20-44
//背景透明层高：bgTransHeight=bgHeight-_naviHeight, Y坐标：_naviHeight
//屏幕宽：bgWidth＝375; 左右边缘宽：16;

//备注：自定义导航栏高度；设置导航栏title属性（多维字典）位置调不了；设置状态栏文字颜色为亮色；image当作uicolor(pattern)用； uiview们的层级

import UIKit
//global data set of ExpenseCategory and IncomeCategory, Singleton
var selectedYear: Int?
var selectedMonth: Int?
var selectedDay: Int?

class homeViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIPickerViewDataSource,UIPickerViewDelegate {

    var monthStrArray: NSArray?
    var indexOfFirstDay: Int?
    var indexOfLastDay: Int?
    var mthBtn = UIButton()
    var mthPicker: UIPickerView?
    var bgMask: UILabel?
    var calndrCollectionView: UICollectionView?
    var tabCalndrBtn   = UIButton()
    var tabAnalyBtn    = UIButton()
    var currentDate: NSString?
    var mthPickerDSyear:[Int] = []
//    var mthLabExpense:UILabel?
//    var mthLabIncome:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //database create is not exists
//        deleteDatabase()
//        BIExpense.deleteTableInDatabase()
//        BIIncome.deleteTableInDatabase()
        createDatabaseOnceIfNotExists()
        //picker数据源
        currentDate = NSDate().description as NSString
        selectedYear  = currentDate!.substringToIndex(4).toInt()!
        selectedMonth = currentDate!.substringWithRange(NSRange(location: 5, length: 2)).toInt()!
        println("\(selectedMonth)")
        for i in 0...99 {
            mthPickerDSyear.append(selectedYear! - 99 + i)
        }
        
        //高度计算
        var bgWidth  = UIScreen.mainScreen().bounds.size.width
        var bgHeight = UIScreen.mainScreen().bounds.size.height
        var naviHeight      = self.navigationController?.navigationBar.frame.height
        var naviY           = self.navigationController?.navigationBar.frame.origin.y
        var _naviRatio      = 0.15 as CGFloat
        var _naviHeight     = bgHeight * _naviRatio
        var naviImageHeight = _naviHeight - naviY! - naviHeight!
        var bgTransHeight   = bgHeight * (1 - _naviRatio)
        var tabHeight = bgHeight*0.15
        var mthHeight       = 60.0 as CGFloat

        
        //背景 bg
        var bgImage = UIImageView(frame: CGRect(x: 0, y: 0, width: bgWidth, height: bgHeight))
        bgImage.image = UIImage(named: "background1")
        self.view.addSubview(bgImage)
        
        var bgTrans = UIImageView(frame: CGRect(x: 0, y: _naviHeight, width: bgWidth, height: bgTransHeight))
        bgTrans.image = UIImage(named: "background2")
        self.view.addSubview(bgTrans)

        //导航 navi
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Navigator"), forBarMetrics: UIBarMetrics.Default)
        var naviImage   = UIImageView(frame: CGRect(x: 0, y: naviHeight!, width: bgWidth, height: naviImageHeight))
        var naviLabel   = UILabel(frame: CGRect(x: bgWidth/2 - 100, y: 0, width: 200, height: _naviHeight - 20))
        
        naviImage.image = UIImage(named: "Navigator")
        naviLabel.text  = "Billinfo"
        naviLabel.textAlignment = NSTextAlignment.Center
        naviLabel.textColor = UIColor.whiteColor()
        naviLabel.font  = UIFont.boldSystemFontOfSize(27)
        naviLabel.tag = 1
        self.navigationController?.navigationBar.addSubview(naviImage)
        self.navigationController?.navigationBar.addSubview(naviLabel)
        
        //月收支 mth
        mthBtn = UIButton(frame: CGRect(x: 0, y: _naviHeight, width: bgWidth/3, height: mthHeight))
        var mthBtnImage = UIImageView(frame: CGRect(x: 0, y: _naviHeight, width: bgWidth/3, height: mthHeight))
        var mthLabExpense = UILabel(frame: CGRect(x: bgWidth/3, y: _naviHeight, width: bgWidth/3, height: mthHeight))
        var mthLabIncome  = UILabel(frame: CGRect(x: bgWidth/3*2, y: _naviHeight, width: bgWidth/3, height: mthHeight))
        var mthLabExpenseImage = UIImageView(frame: CGRect(x: bgWidth/3, y: _naviHeight, width: bgWidth/3, height: mthHeight))
        var mthLabIncomeImage  = UIImageView(frame: CGRect(x: bgWidth/3*2, y: _naviHeight, width: bgWidth/3, height: mthHeight))
        var mthLine = UILabel(frame: CGRect(x: bgWidth/3, y: _naviHeight, width: 0.5, height: mthHeight))
        var mthLine2 = UILabel(frame: CGRect(x: bgWidth/3*2, y: _naviHeight, width: 0.5, height: mthHeight))
        
        mthPicker = UIPickerView(frame: CGRect(x: 0, y: _naviHeight + mthHeight, width: 200, height: bgHeight))
        mthPicker!.dataSource = self
        mthPicker!.delegate   = self
        mthPicker?.backgroundColor = UIColor.whiteColor()
        mthPicker?.hidden = true
        mthPicker!.selectRow(mthPickerDSyear.count - 1, inComponent: 0, animated: false)
        mthPicker!.selectRow(selectedMonth! - 1, inComponent: 1, animated: false)
        
        bgMask = UILabel(frame: CGRect(x: 0, y: _naviHeight + mthHeight, width: bgWidth, height: bgHeight))
        bgMask!.backgroundColor = UIColor(white: 0.2, alpha: 0.3)
        bgMask?.hidden = true
        
        mthBtn.backgroundColor = UIColor.clearColor()
        mthBtn.setTitle("\(selectedYear!)-\(selectedMonth!)", forState: UIControlState.Normal)
        mthBtn.addTarget(self, action: "mtnBtnTouch", forControlEvents: UIControlEvents.TouchUpInside)
        mthBtnImage.image = UIImage(named: "btnMonth")
        
        mthLabExpense.backgroundColor = UIColor.clearColor()
        mthLabExpense.textColor = UIColor.whiteColor()
        mthLabExpense.text = BIExpense.monthSum(year: selectedYear!, month: selectedMonth!)//"-3,000"
        mthLabExpense.textAlignment = NSTextAlignment.Center
        mthLabExpenseImage.image = UIImage(named: "label")
        
        mthLabIncome.backgroundColor = UIColor.clearColor()
        mthLabIncome.text  = BIIncome.monthSum(year: selectedYear!, month: selectedMonth!)//"+1,000"
        mthLabIncome.textColor = UIColor.whiteColor()
        mthLabIncome.textAlignment = NSTextAlignment.Center
        mthLabIncomeImage.image  = UIImage(named: "label")
        
        mthLine.backgroundColor = UIColor.whiteColor()
        mthLine2.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(mthBtnImage)
        self.view.addSubview(mthLabExpenseImage)
        self.view.addSubview(mthLabIncomeImage)
        self.view.addSubview(mthBtn)
        self.view.addSubview(mthLabExpense)
        self.view.addSubview(mthLabIncome)
        self.view.addSubview(mthLine)
        self.view.addSubview(mthLine2)
        self.view.addSubview(mthPicker!)
        self.view.addSubview(bgMask!)

        
        //日历 calndr
        var flowLayOut = UICollectionViewFlowLayout()
        calndrCollectionView = UICollectionView(frame: CGRect(x: 26, y: 300, width: bgWidth - 50, height: 250), collectionViewLayout: flowLayOut)
        calndrCollectionView!.dataSource = self
        calndrCollectionView!.delegate   = self
        calndrCollectionView?.backgroundColor = UIColor.clearColor()
        var calndrBG = UIImageView(frame: CGRect(x: calndrCollectionView!.frame.origin.x - 11, y: calndrCollectionView!.frame.origin.y - 50, width: calndrCollectionView!.frame.width + 20, height: calndrCollectionView!.frame.height + 50))
        calndrBG.image = UIImage(named: "calendarBG2")
        self.view.addSubview(calndrBG)
        self.view.addSubview(calndrCollectionView!)
        
        
        //下标签 tab
        var tabCalndrTransR   = UIImageView(frame: CGRect(x: bgWidth/2, y: bgHeight - tabHeight, width: bgWidth/2, height: tabHeight))
        tabCalndrTransR.image = UIImage(named: "tabTransR")
        
        var tabCalndrImage = UIImageView(frame: CGRect(x: bgWidth/4 - tabHeight/2, y: bgHeight - tabHeight*0.9, width: tabHeight*0.8, height: tabHeight*0.8))
        tabCalndrImage.image = UIImage(named: "calendar")
        tabCalndrBtn   = UIButton(frame: CGRect(x: 0, y: bgHeight - tabHeight, width: bgWidth/2, height: tabHeight))
        tabCalndrBtn.backgroundColor = UIColor.clearColor()
        
        var tabAnalyImage  = UIImageView(frame: CGRect(x: bgWidth/4*3 - tabHeight/2, y: bgHeight - tabHeight*0.9, width: tabHeight*0.8, height: tabHeight*0.8))
        tabAnalyImage.image = UIImage(named: "analysis2")
        tabAnalyBtn    = UIButton(frame: CGRect(x: bgWidth/2, y: bgHeight - tabHeight, width: bgWidth/2, height: tabHeight))
        tabAnalyBtn.backgroundColor = UIColor.clearColor()

        self.view.addSubview(tabCalndrTransR)
        self.view.addSubview(tabCalndrImage)
        self.view.addSubview(tabCalndrBtn)
        self.view.addSubview(tabAnalyImage)
        self.view.addSubview(tabAnalyBtn)
        
        
        //月历
//        self.monthStrArray = NSArray(array: BIMonthCalender(dateForMonthCalender: NSDate.dateFor(year: 2015, month: 6, day: 1)).monthCalender())
        self.monthStrArray = NSArray(array: BIMonthCalender(dateForMonthCalender: NSDate.dateFor(year: selectedYear!, month: selectedMonth!)).monthCalender())
        indexOfFirstDay = self.monthStrArray?.indexOfObject("1")
        indexOfLastDay = (self.monthStrArray?.indexOfObject("1", inRange: NSRange(location: indexOfFirstDay! + 1, length: 41 - indexOfFirstDay!)))! - 1
        println("\(indexOfFirstDay) and \(indexOfLastDay)")
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
    func mtnBtnTouch() {
        //test
        //self.navigationController?.pushViewController(TestViewController(), animated: true)
        
        //展开
        if mthPicker!.hidden {
            mthPicker!.hidden = false
            bgMask?.hidden = false
            self.view.bringSubviewToFront(bgMask!)
            self.view.bringSubviewToFront(mthPicker!)
            calndrCollectionView?.userInteractionEnabled = false
            tabCalndrBtn.userInteractionEnabled = false
            tabAnalyBtn.userInteractionEnabled = false
        //关闭
        }else{
            mthPicker!.hidden = true
            bgMask?.hidden = true
            mthBtn.setTitle("\(selectedYear!)-\(selectedMonth!)", forState: UIControlState.Normal)
            monthStrArray = NSArray(array: BIMonthCalender(dateForMonthCalender: NSDate.dateFor(year: selectedYear!, month: selectedMonth!)).monthCalender())
            indexOfFirstDay = self.monthStrArray?.indexOfObject("1")
            indexOfLastDay = (self.monthStrArray?.indexOfObject("1", inRange: NSRange(location: indexOfFirstDay! + 1, length: 41 - indexOfFirstDay!)))! - 1
            println("\(indexOfFirstDay) and \(indexOfLastDay)")

            calndrCollectionView?.reloadData()
            calndrCollectionView?.userInteractionEnabled = true
            tabCalndrBtn.userInteractionEnabled = true
            tabAnalyBtn.userInteractionEnabled = true
        }
    }
    
    
    //日历 cell
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        collectionView.registerClass(calndrCollectionViewCell.self, forCellWithReuseIdentifier: "myCell")
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("myCell", forIndexPath: indexPath) as? calndrCollectionViewCell
        cell?.textLabel?.text = self.monthStrArray?.objectAtIndex(indexPath.item) as? String
        selectedDay = cell?.textLabel?.text?.toInt()

        //当前月之内
        if (indexPath.item >= indexOfFirstDay && indexPath.item <= indexOfLastDay) {
            cell?.textLabel?.textColor = UIColor.darkGrayColor()
            if (BIExpense.dailyRecords(year: selectedYear!, month: selectedMonth!, day: selectedDay!).count != 0){
                cell?.textLabel?.textColor = UIColor.blueColor()
            }
            if (BIIncome.dailyRecords(year: selectedYear!, month: selectedMonth!, day: (cell?.textLabel?.text?.toInt())!).count != 0){
                cell?.textLabel?.backgroundColor = UIColor.clearColor()
            }
        //上个月和下个月的部分
        }else{
            cell?.textLabel?.textColor = UIColor.lightGrayColor()
            cell?.textLabel?.backgroundColor = UIColor.whiteColor()
        }
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var collectionWidth  = collectionView.frame.width
        var collectionHeight = collectionView.frame.height
        return CGSize(width: collectionWidth/7 - 8, height: collectionHeight/6 - 10)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //当前月之内
        if (indexPath.item >= indexOfFirstDay && indexPath.item <= indexOfLastDay) {
            selectedDay = (self.monthStrArray?.objectAtIndex(indexPath.item) as! String).toInt()
            self.navigationController?.pushViewController(DailyViewController(), animated: true)
        }
    }
    
    
    //主页即将显示时
    override func viewWillAppear(animated: Bool) {
        var naviLabel = self.navigationController?.navigationBar.viewWithTag(1) as! UILabel
        naviLabel.text = "Billinfo"
        self.calndrCollectionView?.reloadData()
       // self.
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
