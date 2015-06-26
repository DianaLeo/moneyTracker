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
var bgWidth  = UIScreen.mainScreen().bounds.size.width
var bgHeight = UIScreen.mainScreen().bounds.size.height

class homeViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var monthStrArray: NSArray?
    var indexOfFirstDay: Int?
    var indexOfLastDay: Int?
    var mthSumView = MonthSummaryView()
    var calndrCollectionView: UICollectionView?
    var calndrBG = UIImageView()
    var tabCalndrBtn   = UIButton()
    var tabAnalyBtn    = UIButton()
    var tabBG          = UIView()
    var scrollView: UIScrollView?
    var analysisViewEx = AnalysisView()
    var analysisViewIn = AnalysisView()
    
    //高度计算
    var naviHeight      = CGFloat()
    var naviY           = CGFloat()
    var _naviRatio      = 0.15 as CGFloat
    var _naviHeight     = CGFloat()
    var naviImageHeight = CGFloat()
    var bgTransHeight   = CGFloat()
    var tabHeight       = CGFloat()
    var mthHeight       = 60.0 as CGFloat
    var scrollHeight    = CGFloat()
    var analysisHeight  = CGFloat()
    
    // MARK: - VC funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        NSThread.sleepForTimeInterval(0.2)

        createDatabaseOnceIfNotExists()
        
        //高度计算
        naviHeight      = (self.navigationController?.navigationBar.frame.height)!
        naviY           = (self.navigationController?.navigationBar.frame.origin.y)!
        _naviHeight     = bgHeight * _naviRatio
        naviImageHeight = _naviHeight - naviY - naviHeight
        bgTransHeight   = bgHeight * (1 - _naviRatio)
        tabHeight       = bgHeight*0.13
        scrollHeight    = bgHeight - _naviHeight - mthHeight
        analysisHeight  = bgWidth + 215
        var collectionWidth  = bgWidth - 50
        var collectionHeight = bgWidth*0.67
        var collectionY = (bgHeight - _naviHeight - mthHeight - tabHeight - 0.8*bgWidth)/2 + mthHeight + _naviHeight + 0.13*bgWidth
        
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

        //月总收入支出
        mthSumView = MonthSummaryView(frame: CGRect(x: 0, y: _naviHeight, width: bgWidth, height: bgHeight))
        mthSumView.mthBtn.addTarget(self, action: "mtnBtnTouch", forControlEvents: UIControlEvents.TouchUpInside)
        mthSumView.bgMask.addTarget(self, action: "mthPickerDismiss", forControlEvents: UIControlEvents.TouchUpInside)
        mthSumView.bgMaskTop.addTarget(self, action: "mthPickerDismiss", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(mthSumView)
        
        //日历 calndr
        var flowLayOut = UICollectionViewFlowLayout()
        flowLayOut.minimumLineSpacing = 10
        flowLayOut.minimumInteritemSpacing = 8
        flowLayOut.itemSize = CGSize(width: collectionWidth/7 - 8, height: collectionHeight/6 - 10)
        calndrCollectionView = UICollectionView(frame: CGRect(x: 26, y: collectionY, width: bgWidth - 50, height: collectionHeight), collectionViewLayout: flowLayOut)
        calndrCollectionView!.dataSource = self
        calndrCollectionView!.delegate   = self
        calndrCollectionView?.backgroundColor = UIColor.clearColor()
        calndrBG = UIImageView(frame: CGRect(x: calndrCollectionView!.frame.origin.x - 11, y: collectionY - bgWidth*0.13, width: collectionWidth + 20, height: collectionHeight + bgWidth*0.13))
        calndrBG.image = UIImage(named: "calendarBG2")
        self.view.addSubview(calndrBG)
        self.view.addSubview(calndrCollectionView!)
        
        //月账分析
        analysisViewEx = AnalysisView(frame: CGRect(x: 0, y: 0, width: bgWidth, height: analysisHeight))
        analysisViewIn = AnalysisView(frame: CGRect(x: 0, y: analysisHeight, width: bgWidth, height: analysisHeight))
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
        scrollView?.contentSize = CGSize(width: 0, height: analysisHeight*2)
        scrollView?.addSubview(analysisViewEx)
        scrollView?.addSubview(analysisViewIn)
        scrollView?.hidden = true
        self.view.addSubview(scrollView!)
        
        //下标签 tab
        tabBG = UIView(frame: CGRect(x: 0, y: bgHeight - tabHeight, width: bgWidth, height: tabHeight))
        tabBG.backgroundColor = UIColor(white: 1, alpha: 0.4)
        tabCalndrBtn   = UIButton(frame: CGRect(x: 8, y: bgHeight - tabHeight, width: tabHeight - 10, height: tabHeight - 10))//x: bgWidth/4 - tabHeight/2
        tabCalndrBtn.setBackgroundImage(UIImage(named: "calendar"), forState: UIControlState.Normal)
        tabCalndrBtn.setBackgroundImage(UIImage(named: "calendar-selected"), forState: UIControlState.Selected)
        tabCalndrBtn.addTarget(self, action: "tabCalndrBtnTouch", forControlEvents: UIControlEvents.TouchDown)
        tabCalndrBtn.selected = true
        
        tabAnalyBtn    = UIButton(frame: CGRect(x: bgWidth - (tabHeight - 10) - 8, y: bgHeight - tabHeight, width: tabHeight - 10, height: tabHeight - 10))//x: 3*bgWidth/4 - tabHeight/2
        tabAnalyBtn.setBackgroundImage(UIImage(named: "analysis"), forState: UIControlState.Normal)
        tabAnalyBtn.setBackgroundImage(UIImage(named: "analysis-selected"), forState: UIControlState.Selected)
        tabAnalyBtn.backgroundColor = UIColor.clearColor()
        tabAnalyBtn.addTarget(self, action: "tabAnalyBtnTouch", forControlEvents: UIControlEvents.TouchDown)
        tabAnalyBtn.selected = false
        //self.view.addSubview(tabBG)
        self.view.addSubview(tabCalndrBtn)
        self.view.addSubview(tabAnalyBtn)
        
        
        //月历
        self.monthStrArray = NSArray(array: BIMonthCalender(dateForMonthCalender: NSDate.dateFor(year: selectedYear!, month: selectedMonth!)).monthCalender())
        indexOfFirstDay = self.monthStrArray?.indexOfObject("1")
        indexOfLastDay = (self.monthStrArray?.indexOfObject("1", inRange: NSRange(location: indexOfFirstDay! + 1, length: 41 - indexOfFirstDay!)))! - 1
    }
    
    //主页即将显示时
    override func viewWillAppear(animated: Bool) {
        var naviLabel  = self.navigationController?.navigationBar.viewWithTag(1) as! UILabel
        naviLabel.text = "MoneyBook"
        
        var naviBtnNew = UIButton(frame: CGRect(x: bgWidth - 70, y: bgHeight*0.015, width: 55, height: 55))
        naviBtnNew.setBackgroundImage(UIImage(named: "new"), forState: UIControlState.Normal)
        naviBtnNew.addTarget(self, action: "naviBtnNewTouch", forControlEvents: UIControlEvents.TouchUpInside)
        naviBtnNew.tag = 2
        
        self.navigationController?.navigationBar.addSubview(naviBtnNew)
        self.calndrCollectionView?.reloadData()
        mthSumView.mthLabExpense.text = "Expense:\n\(BIExpense.monthSum(year: selectedYear!, month: selectedMonth!))"
        mthSumView.mthLabIncome.text  = "Income:\n\(BIIncome.monthSum(year: selectedYear!, month: selectedMonth!))"
    }
    
    
    
    // MARK: - 日历 cell
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        collectionView.registerClass(calndrCollectionViewCell.self, forCellWithReuseIdentifier: "myCell")
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("myCell", forIndexPath: indexPath) as? calndrCollectionViewCell
        var btnTitle = self.monthStrArray?.objectAtIndex(indexPath.item) as? String
        cell?.textBtn?.text = btnTitle
        
        selectedDay = btnTitle?.toInt()
        //当前月之内
        if (indexPath.item >= indexOfFirstDay && indexPath.item <= indexOfLastDay) {
            if ((BIExpense.dailyRecords(year: selectedYear!, month: selectedMonth!, day: selectedDay!).count != 0)&&(BIIncome.dailyRecords(year: selectedYear!, month: selectedMonth!, day: selectedDay!).count != 0)){
                cell?.textBtn?.textColor = UIColor.blueColor()
                cell?.imageView?.hidden = false
            }
            else if (BIExpense.dailyRecords(year: selectedYear!, month: selectedMonth!, day: selectedDay!).count != 0){
                cell?.textBtn?.textColor = UIColor.blueColor()
                cell?.imageView?.hidden = true
            }
            else if (BIIncome.dailyRecords(year: selectedYear!, month: selectedMonth!, day: selectedDay!).count != 0){
                cell?.textBtn?.textColor = UIColor.darkGrayColor()
                cell?.imageView?.hidden = false
            }
            else{
                cell?.textBtn?.textColor = UIColor.darkGrayColor()
                cell?.imageView?.hidden = true
            }
            //上个月和下个月的部分
        }else{
            cell?.textBtn?.textColor = UIColor.lightGrayColor()
            cell?.imageView?.hidden = true
        }
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        NSThread.sleepForTimeInterval(0.1)
        //当前月之内
        if (indexPath.item >= indexOfFirstDay && indexPath.item <= indexOfLastDay) {
            selectedDay = (self.monthStrArray?.objectAtIndex(indexPath.item) as! String).toInt()
            var naviBtnNew = self.navigationController?.navigationBar.viewWithTag(2) as! UIButton
            naviBtnNew.removeFromSuperview()
            self.navigationController?.pushViewController(DailyViewController(), animated: true)
        }
    }

    
    
    
    // MARK: - Utilities
    
    //导航栏“新建“按钮点击
    func naviBtnNewTouch () {
        var naviBtnNew = self.navigationController?.navigationBar.viewWithTag(2) as! UIButton
        naviBtnNew.removeFromSuperview()
        var newViewController = NewViewController()
        self.navigationController?.pushViewController(newViewController, animated: true)
        isModificationMode = false
        isFromRootVC       = true
    }
    
    func tabCalndrBtnTouch (){
        tabCalndrBtn.selected = true
        tabAnalyBtn.selected  = false
        scrollView?.hidden = true
        calndrCollectionView?.hidden = false
        calndrBG.hidden = false
    }
    
    func tabAnalyBtnTouch(){
        tabAnalyBtn.selected  = true
        tabCalndrBtn.selected = false
        scrollView?.hidden = false
        calndrCollectionView?.hidden = true
        calndrBG.hidden = true
        
        var analysis = BIBillAnalysis(year: selectedYear!, month: selectedMonth!)
        analysisViewEx.passValue(passedCategories: analysis.expCatSix, passedRatios: analysis.expSix)
        analysisViewIn.passValue(passedCategories: analysis.incCatSix, passedRatios: analysis.incSix)
        analysisViewEx.drawLegends()
        analysisViewIn.drawLegends()
        analysisViewEx.setNeedsDisplay()
        analysisViewIn.setNeedsDisplay()
    }
    
    func mtnBtnTouch() {
        if mthSumView.mthPicker.hidden {
            NSThread.sleepForTimeInterval(0.1)
            mthSumView.mthBtnAngle.hidden = true
            mthSumView.mthPicker.hidden = false
            mthSumView.bgMask.hidden = false
            mthSumView.bgMaskTop.hidden = false
            self.view.bringSubviewToFront(mthSumView)
            calndrCollectionView?.userInteractionEnabled = false
            tabCalndrBtn.userInteractionEnabled = false
            tabAnalyBtn.userInteractionEnabled = false
        }else{
            mthPickerDismiss()
        }
    }
    //mthPicker关闭
    func mthPickerDismiss(){
        mthSumView.mthBtnAngle.hidden = false
        mthSumView.mthPicker.hidden = true
        mthSumView.bgMask.hidden = true
        mthSumView.bgMaskTop.hidden = true
        mthSumView.mthBtn.setTitle("\(selectedYear!)-\(selectedMonth!)", forState: UIControlState.Normal)
        monthStrArray = NSArray(array: BIMonthCalender(dateForMonthCalender: NSDate.dateFor(year: selectedYear!, month: selectedMonth!)).monthCalender())
        mthSumView.mthLabExpense.text = "Expense:\n\(BIExpense.monthSum(year: selectedYear!, month: selectedMonth!))"
        mthSumView.mthLabIncome.text  = "Income:\n\(BIIncome.monthSum(year: selectedYear!, month: selectedMonth!))"
        self.view.bringSubviewToFront(calndrCollectionView!)
        self.view.bringSubviewToFront(tabCalndrBtn)
        self.view.bringSubviewToFront(tabAnalyBtn)
        indexOfFirstDay = self.monthStrArray?.indexOfObject("1")
        indexOfLastDay  = (self.monthStrArray?.indexOfObject("1", inRange: NSRange(location: indexOfFirstDay! + 1, length: 41 - indexOfFirstDay!)))! - 1
        
        calndrCollectionView?.reloadData()
        calndrCollectionView?.userInteractionEnabled = true
        tabCalndrBtn.userInteractionEnabled = true
        tabAnalyBtn.userInteractionEnabled = true
        
        var analysis = BIBillAnalysis(year: selectedYear!, month: selectedMonth!)
        analysisViewEx.passValue(passedCategories: analysis.expCatSix, passedRatios: analysis.expSix)
        analysisViewIn.passValue(passedCategories: analysis.incCatSix, passedRatios: analysis.incSix)
        analysisViewEx.drawLegends()
        analysisViewIn.drawLegends()
        analysisViewEx.setNeedsDisplay()
        analysisViewIn.setNeedsDisplay()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
