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

//备注：自定义导航栏高度；设置导航栏title属性（多维字典）位置调不了；设置状态栏文字颜色为亮色；image当作uicolor(pattern)用； uiview们的层级；UIlabel圆角矩形; 四舍五入

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
    var mthBtnImage = UIImageView()
    var mthPicker: UIPickerView?
    var bgMask: UILabel?
    var calndrCollectionView: UICollectionView?
    var calndrBG = UIImageView()
    var tabCalndrBtn   = UIButton()
    var tabAnalyBtn    = UIButton()
    var currentDate: NSString?
    var mthPickerDSyear:[Int] = []
    var scrollView: UIScrollView?
    var tabTransL = UIImageView()
    var tabTransR = UIImageView()
    var analysisViewEx = AnalysisView()
    var analysisViewIn = AnalysisView()
    var mthLabExpense2 = UILabel()
    var mthLabIncome2 = UILabel()
    //    var mthLabExpense:UILabel?
    //    var mthLabIncome:UILabel?
    //高度计算
    var bgWidth  = UIScreen.mainScreen().bounds.size.width
    var bgHeight = UIScreen.mainScreen().bounds.size.height
    var naviHeight      = CGFloat()
    var naviY           = CGFloat()
    var _naviRatio      = 0.15 as CGFloat
    var _naviHeight     = CGFloat()
    var naviImageHeight = CGFloat()
    var bgTransHeight   = CGFloat()
    var tabHeight       = CGFloat()
    var mthHeight       = 60.0 as CGFloat
    var scrollHeight    = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //延时1秒
        NSThread.sleepForTimeInterval(0.5)

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
        naviHeight      = (self.navigationController?.navigationBar.frame.height)!
        naviY           = (self.navigationController?.navigationBar.frame.origin.y)!
        _naviHeight     = bgHeight * _naviRatio
        naviImageHeight = _naviHeight - naviY - naviHeight
        bgTransHeight   = bgHeight * (1 - _naviRatio)
        tabHeight       = bgHeight*0.15
        scrollHeight    = bgHeight - _naviHeight - mthHeight - tabHeight
        
        //背景 bg
        var bgImage = UIImageView(frame: CGRect(x: 0, y: 0, width: bgWidth, height: bgHeight))
        bgImage.image = UIImage(named: "background1")
        self.view.addSubview(bgImage)
        
        var bgTrans = UIImageView(frame: CGRect(x: 0, y: _naviHeight, width: bgWidth, height: bgTransHeight))
        bgTrans.image = UIImage(named: "background2")
        self.view.addSubview(bgTrans)
        
        //导航 navi
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Navigator"), forBarMetrics: UIBarMetrics.Default)
        var naviImage   = UIImageView(frame: CGRect(x: 0, y: naviHeight, width: bgWidth, height: naviImageHeight))
        naviImage.image = UIImage(named: "Navigator")

        var naviLabel   = UILabel(frame: CGRect(x: bgWidth/2 - 100, y: 0, width: 200, height: _naviHeight - 20))
        naviLabel.text  = "Billinfo"
        naviLabel.textAlignment = NSTextAlignment.Center
        naviLabel.textColor = UIColor.whiteColor()
        naviLabel.font  = UIFont.boldSystemFontOfSize(27)
        naviLabel.tag = 1
        
        self.navigationController?.navigationBar.addSubview(naviImage)
        self.navigationController?.navigationBar.addSubview(naviLabel)
        
        //月收支 mth
        mthBtn = UIButton(frame: CGRect(x: 0, y: _naviHeight, width: bgWidth/3, height: mthHeight))
        mthBtnImage = UIImageView(frame: CGRect(x: 0, y: _naviHeight, width: bgWidth/3, height: mthHeight))
        var mthLabExpense  = UILabel(frame: CGRect(x: bgWidth/3, y: _naviHeight, width: bgWidth/3, height: mthHeight/2))
        mthLabExpense2 = UILabel(frame: CGRect(x: bgWidth/3, y: _naviHeight + mthHeight/2, width: bgWidth/3, height: mthHeight/2))
        var mthLabIncome  = UILabel(frame: CGRect(x: bgWidth/3*2, y: _naviHeight, width: bgWidth/3, height: mthHeight/2))
        mthLabIncome2 = UILabel(frame: CGRect(x: bgWidth/3*2, y: _naviHeight + mthHeight/2, width: bgWidth/3, height: mthHeight/2))
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
        
        mthLabExpense.text = "Expense:"
        mthLabExpense.textAlignment = NSTextAlignment.Center
        mthLabExpense.textColor = UIColor.whiteColor()
        mthLabExpense2.text = BIExpense.monthSum(year: selectedYear!, month: selectedMonth!)
        mthLabExpense2.textAlignment = NSTextAlignment.Center
        mthLabExpense2.textColor = UIColor.whiteColor()
        mthLabExpenseImage.image = UIImage(named: "label")
        
        mthLabIncome.text  = "Income:"
        mthLabIncome.textAlignment = NSTextAlignment.Center
        mthLabIncome.textColor = UIColor.whiteColor()
        mthLabIncome2.text = BIIncome.monthSum(year: selectedYear!, month: selectedMonth!)
        mthLabIncome2.textAlignment = NSTextAlignment.Center
        mthLabIncome2.textColor = UIColor.whiteColor()
        mthLabIncomeImage.image  = UIImage(named: "label")
        
        mthLine.backgroundColor = UIColor.whiteColor()
        mthLine2.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(mthBtnImage)
        self.view.addSubview(mthLabExpenseImage)
        self.view.addSubview(mthLabIncomeImage)
        self.view.addSubview(mthBtn)
        self.view.addSubview(mthLabExpense)
        self.view.addSubview(mthLabExpense2)
        self.view.addSubview(mthLabIncome)
        self.view.addSubview(mthLabIncome2)
        self.view.addSubview(mthLine)
        self.view.addSubview(mthLine2)
        self.view.addSubview(mthPicker!)
        self.view.addSubview(bgMask!)
        
        
        //日历 calndr
        var flowLayOut = UICollectionViewFlowLayout()
        println("scrollHeight:\(scrollHeight)")
        calndrCollectionView = UICollectionView(frame: CGRect(x: 26, y: _naviHeight + mthHeight + (scrollHeight - bgWidth*0.8)*0.5 + bgWidth*0.13, width: bgWidth - 50, height: bgWidth*0.67), collectionViewLayout: flowLayOut)
        calndrCollectionView!.dataSource = self
        calndrCollectionView!.delegate   = self
        calndrCollectionView?.backgroundColor = UIColor.clearColor()
        calndrBG = UIImageView(frame: CGRect(x: calndrCollectionView!.frame.origin.x - 11, y: calndrCollectionView!.frame.origin.y - bgWidth*0.13, width: calndrCollectionView!.frame.width + 20, height: calndrCollectionView!.frame.height + bgWidth*0.13))
        calndrBG.image = UIImage(named: "calendarBG2")
        self.view.addSubview(calndrBG)
        self.view.addSubview(calndrCollectionView!)
        
        //月账分析
        analysisViewEx = AnalysisView(frame: CGRect(x: 0, y: 0, width: bgWidth, height: scrollHeight + 220))
        analysisViewIn = AnalysisView(frame: CGRect(x: 0, y: scrollHeight + 250, width: bgWidth, height: scrollHeight + 220))
        analysisViewEx.backgroundColor = UIColor.clearColor()
        analysisViewIn.backgroundColor = UIColor.clearColor()
        analysisViewEx.title.text = "Expense:"
        analysisViewIn.title.text = "Income:"
        var analysis = BIBillAnalysis(year: selectedYear!, month: selectedMonth!)
        analysisViewEx.passValue(passedCategories: analysis.expCatSix, passedRatios: analysis.expSix)
        analysisViewIn.passValue(passedCategories: analysis.incCatSix , passedRatios: analysis.incSix)
        println(analysis.incSix)

        //ScrollView
        scrollView = UIScrollView(frame: CGRect(x: 0, y: _naviHeight + mthHeight, width: bgWidth, height: scrollHeight))
        scrollView?.indicatorStyle = UIScrollViewIndicatorStyle.Default
        scrollView?.bounces = false
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.contentSize = CGSize(width: 0, height: (scrollHeight + 220)*2)
        scrollView?.addSubview(analysisViewEx)
        scrollView?.addSubview(analysisViewIn)
        scrollView?.hidden = true
        self.view.addSubview(scrollView!)
        
        //下标签 tab
        tabTransL   = UIImageView(frame: CGRect(x: 0, y: bgHeight - tabHeight, width: bgWidth/2, height: tabHeight))
        tabTransL.image = UIImage(named: "tabTransL")
        tabTransL.hidden = true
        var tabCalndrImage = UIImageView(frame: CGRect(x: bgWidth/4 - tabHeight/2, y: bgHeight - tabHeight*0.9, width: tabHeight*0.8, height: tabHeight*0.8))
        tabCalndrImage.image = UIImage(named: "calendar")
        tabCalndrBtn   = UIButton(frame: CGRect(x: 0, y: bgHeight - tabHeight, width: bgWidth/2, height: tabHeight))
        tabCalndrBtn.backgroundColor = UIColor.clearColor()
        tabCalndrBtn.addTarget(self, action: "tabCalndrBtnTouch", forControlEvents: UIControlEvents.TouchDown)
        
        tabTransR   = UIImageView(frame: CGRect(x: bgWidth/2, y: bgHeight - tabHeight, width: bgWidth/2, height: tabHeight))
        tabTransR.image = UIImage(named: "tabTransR")
        var tabAnalyImage  = UIImageView(frame: CGRect(x: bgWidth/4*3 - tabHeight/2, y: bgHeight - tabHeight*0.9, width: tabHeight*0.8, height: tabHeight*0.8))
        tabAnalyImage.image = UIImage(named: "analysis2")
        tabAnalyBtn    = UIButton(frame: CGRect(x: bgWidth/2, y: bgHeight - tabHeight, width: bgWidth/2, height: tabHeight))
        tabAnalyBtn.backgroundColor = UIColor.clearColor()
        tabAnalyBtn.addTarget(self, action: "tabAnalyBtnTouch", forControlEvents: UIControlEvents.TouchDown)
        
        self.view.addSubview(tabTransR)
        self.view.addSubview(tabTransL)
        self.view.addSubview(tabCalndrImage)
        self.view.addSubview(tabCalndrBtn)
        self.view.addSubview(tabAnalyImage)
        self.view.addSubview(tabAnalyBtn)
        
        
        //月历
        //        self.monthStrArray = NSArray(array: BIMonthCalender(dateForMonthCalender: NSDate.dateFor(year: 2015, month: 6, day: 1)).monthCalender())
        self.monthStrArray = NSArray(array: BIMonthCalender(dateForMonthCalender: NSDate.dateFor(year: selectedYear!, month: selectedMonth!)).monthCalender())
        indexOfFirstDay = self.monthStrArray?.indexOfObject("1")
        indexOfLastDay = (self.monthStrArray?.indexOfObject("1", inRange: NSRange(location: indexOfFirstDay! + 1, length: 41 - indexOfFirstDay!)))! - 1
    }

    
    func tabCalndrBtnTouch (){
        tabTransL.hidden = true
        tabTransR.hidden = false
        
        scrollView?.hidden = true
        calndrCollectionView?.hidden = false
        calndrBG.hidden = false
    }
    
    func tabAnalyBtnTouch(){
        tabTransL.hidden = false
        tabTransR.hidden = true
        
        scrollView?.hidden = false
        calndrCollectionView?.hidden = true
        calndrBG.hidden = true
        //scrollView?.contentSize = CGSizeMake(0, scrollHeight + 100)

        var analysis = BIBillAnalysis(year: selectedYear!, month: selectedMonth!)
        analysisViewEx.passValue(passedCategories: analysis.expCatSix, passedRatios: analysis.expSix)
        analysisViewIn.passValue(passedCategories: analysis.incCatSix, passedRatios: analysis.incSix)
        analysisViewEx.drawLegends()
        analysisViewIn.drawLegends()
        analysisViewEx.setNeedsDisplay()
        analysisViewIn.setNeedsDisplay()
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
    
    func mtnBtnTouch() {
        //展开
        if mthPicker!.hidden {
            mthPicker!.hidden = false
            bgMask?.hidden = false
            self.view.bringSubviewToFront(bgMask!)
            self.view.bringSubviewToFront(mthPicker!)
            calndrCollectionView?.userInteractionEnabled = false
            tabCalndrBtn.userInteractionEnabled = false
            tabAnalyBtn.userInteractionEnabled = false
            mthBtn.backgroundColor = UIColor(red: 0.94, green: 0.78, blue: 0.71, alpha: 1)//pink
            mthBtnImage.hidden = true
        //关闭
        }else{
            mthPicker!.hidden = true
            bgMask?.hidden = true
            mthBtn.setTitle("\(selectedYear!)-\(selectedMonth!)", forState: UIControlState.Normal)
            mthBtn.backgroundColor = UIColor.clearColor()
            mthBtnImage.hidden = false
            monthStrArray = NSArray(array: BIMonthCalender(dateForMonthCalender: NSDate.dateFor(year: selectedYear!, month: selectedMonth!)).monthCalender())
            println("selected:\(selectedYear!)-\(selectedMonth!)")
            mthLabExpense2.text = BIExpense.monthSum(year: selectedYear!, month: selectedMonth!)
            mthLabIncome2.text  = BIIncome.monthSum(year: selectedYear!, month: selectedMonth!)
            
            indexOfFirstDay = self.monthStrArray?.indexOfObject("1")
            indexOfLastDay  = (self.monthStrArray?.indexOfObject("1", inRange: NSRange(location: indexOfFirstDay! + 1, length: 41 - indexOfFirstDay!)))! - 1
            println("\(indexOfFirstDay) and \(indexOfLastDay)")
            
            calndrCollectionView?.reloadData()
            calndrCollectionView?.userInteractionEnabled = true
            tabCalndrBtn.userInteractionEnabled = true
            tabAnalyBtn.userInteractionEnabled = true
            
            var analysis = BIBillAnalysis(year: selectedYear!, month: selectedMonth!)
            analysisViewEx.passValue(passedCategories: analysis.expCatSix, passedRatios: analysis.expSix)
            analysisViewIn.passValue(passedCategories: analysis.incCatSix, passedRatios: analysis.incSix)
            println(analysis.incSix)
            analysisViewEx.drawLegends()
            analysisViewIn.drawLegends()
            analysisViewEx.setNeedsDisplay()
            analysisViewIn.setNeedsDisplay()
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
            if ((BIExpense.dailyRecords(year: selectedYear!, month: selectedMonth!, day: selectedDay!).count != 0)&&(BIIncome.dailyRecords(year: selectedYear!, month: selectedMonth!, day: selectedDay!).count != 0)){
                cell?.textLabel?.textColor = UIColor.blueColor()
                cell?.textLabel?.backgroundColor = UIColor.clearColor()
            }
            else if (BIExpense.dailyRecords(year: selectedYear!, month: selectedMonth!, day: selectedDay!).count != 0){
                cell?.textLabel?.textColor = UIColor.blueColor()
                cell?.textLabel?.backgroundColor = UIColor.whiteColor()
                //cell?.textLabel?.font = UIFont.boldSystemFontOfSize(20)
                println("expense:\(indexPath.item),\(selectedDay!)")
            }
            else if (BIIncome.dailyRecords(year: selectedYear!, month: selectedMonth!, day: selectedDay!).count != 0){
                cell?.textLabel?.textColor = UIColor.darkGrayColor()
                cell?.textLabel?.backgroundColor = UIColor.clearColor()
                //cell?.textLabel?.textColor = UIColor.magentaColor()
                //cell?.textLabel?.font = UIFont.boldSystemFontOfSize(20)
                println("income:\(indexPath.item),\(selectedDay!)")
            }
            else{
                cell?.textLabel?.textColor = UIColor.darkGrayColor()
                cell?.textLabel?.backgroundColor = UIColor.whiteColor()
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
            var naviBtnNew = self.navigationController?.navigationBar.viewWithTag(2) as! UIButton
            var naviBtnNewImg = self.navigationController?.navigationBar.viewWithTag(3) as! UIImageView
            naviBtnNew.removeFromSuperview()
            naviBtnNewImg.removeFromSuperview()
            self.navigationController?.pushViewController(DailyViewController(), animated: true)
        }
    }
    
    
    //主页即将显示时
    override func viewWillAppear(animated: Bool) {
        var naviLabel = self.navigationController?.navigationBar.viewWithTag(1) as! UILabel
        naviLabel.text = "MoneyBook"
        
        var naviBtnNewRect = CGRect(x: bgWidth - 70, y: bgHeight*0.015, width: 55, height: 55)
        var naviBtnNew     = UIButton(frame: naviBtnNewRect)
        var naviBtnNewImg  = UIImageView(frame: naviBtnNewRect)
        naviBtnNewImg.image = UIImage(named: "new")
        naviBtnNew.addSubview(naviBtnNewImg)
        naviBtnNew.addTarget(self, action: "naviBtnNewTouch", forControlEvents: UIControlEvents.TouchUpInside)
        naviBtnNew.tag    = 2
        naviBtnNewImg.tag = 3
        
        self.navigationController?.navigationBar.addSubview(naviBtnNew)
        self.navigationController?.navigationBar.addSubview(naviBtnNewImg)
        self.calndrCollectionView?.reloadData()
        mthLabExpense2.text = BIExpense.monthSum(year: selectedYear!, month: selectedMonth!)
        mthLabIncome2.text = BIIncome.monthSum(year: selectedYear!, month: selectedMonth!)
    }
    
    //导航栏“新建“按钮点击
    func naviBtnNewTouch () {
        var naviBtnNew = self.navigationController?.navigationBar.viewWithTag(2) as! UIButton
        var naviBtnNewImg = self.navigationController?.navigationBar.viewWithTag(3) as! UIImageView
        naviBtnNew.removeFromSuperview()
        naviBtnNewImg.removeFromSuperview()
        var newViewController = NewViewController()
        self.navigationController?.pushViewController(newViewController, animated: true)
        isModificationMode = false
        isFromRootVC       = true
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
