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
class homeViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    //month arrry for calendar
    var monthStrArray: [String]?
    @IBOutlet weak var calndrCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        //        self.navigationItem.title = "Billinfo"
        //        let dic = NSDictionary(objects: [UIColor.whiteColor(),UIFont.systemFontOfSize(50)], forKeys: [NSForegroundColorAttributeName,NSFontAttributeName])
        //        self.navigationController?.navigationBar.titleTextAttributes = dic as [NSObject : AnyObject]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Navigator"), forBarMetrics: UIBarMetrics.Default)
        var naviImage   = UIImageView(frame: CGRect(x: 0, y: naviHeight!, width: bgWidth, height: naviImageHeight))
        var naviLabel   = UILabel(frame: CGRect(x: bgWidth/2 - 50, y: 0, width: 100, height: _naviHeight - 20))
        
        naviImage.image = UIImage(named: "Navigator")
        naviLabel.text  = "Billinfo"
        naviLabel.textAlignment = NSTextAlignment.Center
        naviLabel.textColor = UIColor.whiteColor()
        naviLabel.font  = UIFont.boldSystemFontOfSize(27)
        naviLabel.tag = 1
        self.navigationController?.navigationBar.addSubview(naviImage)
        self.navigationController?.navigationBar.addSubview(naviLabel)
        
        //月收支 mth
        var mthBtnImage        = UIImageView(frame: CGRect(x: 0, y: _naviHeight, width: bgWidth/3, height: mthHeight))
        var mthLabExpenseImage = UIImageView(frame: CGRect(x: bgWidth/3, y: _naviHeight, width: bgWidth/3, height: mthHeight))
        var mthLabIncomeImage  = UIImageView(frame: CGRect(x: bgWidth/3*2, y: _naviHeight, width: bgWidth/3, height: mthHeight))
        mthBtnImage.image = UIImage(named: "btnMonth")
        mthLabExpenseImage.image = UIImage(named: "label")
        mthLabIncomeImage.image  = UIImage(named: "label")
        var mthBtn        = UIButton(frame: CGRect(x: 0, y: _naviHeight, width: bgWidth/3, height: mthHeight))
        var mthLabExpense = UILabel(frame: CGRect(x: bgWidth/3, y: _naviHeight, width: bgWidth/3, height: mthHeight))
        var mthLabIncome  = UILabel(frame: CGRect(x: bgWidth/3*2, y: _naviHeight, width: bgWidth/3, height: mthHeight))
        
        var mthLine       = UILabel(frame: CGRect(x: bgWidth/3, y: _naviHeight, width: 0.5, height: mthHeight))
        var mthLine2      = UILabel(frame: CGRect(x: bgWidth/3*2, y: _naviHeight, width: 0.5, height: mthHeight))
        mthBtn.backgroundColor = UIColor.clearColor()
        mthLabExpense.backgroundColor = UIColor.clearColor()
        mthLabIncome.backgroundColor = UIColor.clearColor()
        mthLine.backgroundColor = UIColor.whiteColor()
        mthLine2.backgroundColor = UIColor.whiteColor()
        mthBtn.setTitle("2015-05", forState: UIControlState.Normal)
        mthLabExpense.text = BIExpense.monthSum()//"-3,000"
        mthLabExpense.textColor = UIColor.whiteColor()
        mthLabExpense.textAlignment = NSTextAlignment.Center
        mthLabIncome.text  = BIIncome.monthSum()//"+1,000"
        mthLabIncome.textColor = UIColor.whiteColor()
        mthLabIncome.textAlignment = NSTextAlignment.Center
        self.view.addSubview(mthBtnImage)
        self.view.addSubview(mthLabExpenseImage)
        self.view.addSubview(mthLabIncomeImage)
        self.view.addSubview(mthBtn)
        self.view.addSubview(mthLabExpense)
        self.view.addSubview(mthLabIncome)
        self.view.addSubview(mthLine)
        self.view.addSubview(mthLine2)
        
        mthBtn.addTarget(self, action: "goToTestVC", forControlEvents: UIControlEvents.TouchUpInside)
        
        //日历 calndr
        calndrCollectionView.dataSource = self
        calndrCollectionView.delegate   = self
        calndrCollectionView.backgroundColor = UIColor.clearColor()
        var calndrBG = UIImageView(frame: CGRect(x: 16, y: calndrCollectionView.frame.origin.y - 50, width: bgWidth - 32, height: calndrCollectionView.frame.height + 50))
        calndrBG.image = UIImage(named: "calendarBG2")
        self.view.addSubview(calndrBG)
        self.view.bringSubviewToFront(calndrCollectionView)
        
//        var collectionView1 = UICollectionView(frame: CGRect(x: 0, y: 150, width: 200, height: 200))
//        collectionView1.backgroundColor = UIColor.magentaColor()
//        self.view.addSubview(collectionView1)
//        collectionView1.dataSource = self
//        collectionView1.delegate   = self
        
        
        //下标签 tab
        var tabCalndrTransR   = UIImageView(frame: CGRect(x: bgWidth/2, y: bgHeight - tabHeight, width: bgWidth/2, height: tabHeight))
        tabCalndrTransR.image = UIImage(named: "tabTransR")
        
        var tabCalndrImage  = UIImageView(frame: CGRect(x: bgWidth/4 - tabHeight/2, y: bgHeight - tabHeight*0.9, width: tabHeight*0.8, height: tabHeight*0.8))
        tabCalndrImage.image = UIImage(named: "calendar")
        var tabCalndr        = UIButton(frame: CGRect(x: 0, y: bgHeight - tabHeight, width: bgWidth/2, height: tabHeight))
        tabCalndr.backgroundColor = UIColor.clearColor()
        
        var tabAnalyImage  = UIImageView(frame: CGRect(x: bgWidth/4*3 - tabHeight/2, y: bgHeight - tabHeight*0.9, width: tabHeight*0.8, height: tabHeight*0.8))
        tabAnalyImage.image = UIImage(named: "analysis2")
        var tabAnaly        = UIButton(frame: CGRect(x: bgWidth/2, y: bgHeight - tabHeight, width: bgWidth/2, height: tabHeight))
        tabAnaly.backgroundColor = UIColor.clearColor()

        self.view.addSubview(tabCalndrTransR)
        self.view.addSubview(tabCalndrImage)
        self.view.addSubview(tabCalndr)
        self.view.addSubview(tabAnalyImage)
        self.view.addSubview(tabAnaly)
        
        //MonthCalender 
        self.monthStrArray = BIMonthCalender(dateForMonthCalender: NSDate()).monthCalender()
        
        
    }
    
    //日历 cell
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        collectionView.registerClass(calndrCollectionViewCell.self, forCellWithReuseIdentifier: "myCell")
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("myCell", forIndexPath: indexPath) as? calndrCollectionViewCell

        //cell?.textLabel?.text = "\(indexPath.item)"
        
        cell?.textLabel?.text = self.monthStrArray![indexPath.item]
        //cell?.textLabel?.backgroundColor = UIColor.clearColor()
        if indexPath == 0 {
            
        }
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var collectionWidth  = collectionView.frame.width
        var collectionHeight = collectionView.frame.height
        return CGSize(width: collectionWidth/7 - 10, height: collectionHeight/6 - 10)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10
    }
    
    //每日收支页面
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.navigationController?.pushViewController(DailyViewController(), animated: true)
    }
    
    //测试页面
    func goToTestVC() {
        self.navigationController?.pushViewController(TestViewController(), animated: true)
    }
    
    //主页即将显示时
    override func viewWillAppear(animated: Bool) {
        //super.viewDidAppear(false)
        var naviLabel = self.navigationController?.navigationBar.viewWithTag(1) as! UILabel
        naviLabel.text = "Billinfo"
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
