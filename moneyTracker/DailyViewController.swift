//
//  DailyTableViewController.swift
//  moneyTracker
//
//  Created by User on 24/05/2015.
//  Copyright (c) 2015 User. All rights reserved.
//

import UIKit

class DailyViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var flagExpense = 1
    var listTable = UITableView()
    var tabBtnEx = UIButton()
    var tabBtnIn = UIButton()
    var tipLabel = UILabel()
    var naviBtnBack = UIButton()
    var naviBtnNew  = UIButton()
    
    var listTableDataSource = NSMutableArray(array: [1,2,3,4])
    var userCategoryDS = BICategory.sharedInstance()
    lazy var dailyExpenseDS = BIExpense.dailyRecords(year: selectedYear!, month: selectedMonth!, day: selectedDay!)
    lazy var dailyIncomeDS = BIIncome.dailyRecords(year: selectedYear!, month: selectedMonth!, day: selectedDay!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //高度计算
        var naviHeight      = self.navigationController?.navigationBar.frame.height
        var naviY           = self.navigationController?.navigationBar.frame.origin.y
        var _naviRatio      = 0.15 as CGFloat
        var _naviHeight     = bgHeight * _naviRatio
        var naviImageHeight = _naviHeight - naviY! - naviHeight!
        var tabHeight       = 50.0 as CGFloat
        
        //背景
        var bgImage = UIImageView(frame: CGRect(x: 0, y: 0, width: bgWidth, height: bgHeight))
        bgImage.image = UIImage(named: "background1")
        var bgTrans = UIImageView(frame: CGRect(x: 0, y: _naviHeight, width: bgWidth, height: bgHeight - _naviHeight))
        bgTrans.image = UIImage(named: "background2")
        var bgTransWhite = UIView(frame: CGRect(x: 0, y: _naviHeight, width: bgWidth, height: bgHeight - _naviHeight))
        bgTransWhite.backgroundColor = UIColor(white: 1, alpha: 0.2)
        self.view.addSubview(bgImage)
        self.view.addSubview(bgTrans)
        self.view.addSubview(bgTransWhite)
        self.navigationItem.hidesBackButton = true
        
        //上标签（收支）tab
        tabBtnEx = UIButton(frame: CGRect(x: 0, y: _naviHeight, width: bgWidth/2, height: tabHeight))
        tabBtnEx.setBackgroundImage(UIImage(named: "dailyTabBtn"), forState: UIControlState.Normal)
        tabBtnEx.setBackgroundImage(UIImage(named: "dailyTabBtn-selected"), forState: UIControlState.Selected)
        tabBtnEx.setTitle("Expense", forState: UIControlState.Normal)
        tabBtnEx.addTarget(self, action: "tabBtnExTouch", forControlEvents: UIControlEvents.TouchUpInside)
        tabBtnEx.selected = true

        tabBtnIn = UIButton(frame: CGRect(x: bgWidth/2, y: _naviHeight, width: bgWidth/2, height: tabHeight))
        tabBtnIn.setBackgroundImage(UIImage(named: "dailyTabBtn"), forState: UIControlState.Normal)
        tabBtnIn.setBackgroundImage(UIImage(named: "dailyTabBtn-selected"), forState: UIControlState.Selected)
        tabBtnIn.setTitle("Income", forState: UIControlState.Normal)
        tabBtnIn.addTarget(self, action: "tabBtnInTouch", forControlEvents: UIControlEvents.TouchUpInside)
        tabBtnIn.selected = false
        
        self.view.addSubview(tabBtnEx)
        self.view.addSubview(tabBtnIn)
        
        tipLabel = UILabel(frame: CGRect(x: (bgWidth - 100)/2, y: _naviHeight + tabHeight + 40, width: 100, height: 30))
        tipLabel.text = "No Record."
        tipLabel.textAlignment = NSTextAlignment.Center
        tipLabel.textColor = UIColor.whiteColor()
        self.view.addSubview(tipLabel)
        
        //详细列表 list
        listTable = UITableView(frame: CGRect(x: 0, y: _naviHeight + tabHeight, width: bgWidth, height: bgHeight - _naviHeight - tabHeight), style: UITableViewStyle.Plain)
        listTable.backgroundColor = UIColor.clearColor()
        listTable.dataSource = self
        listTable.delegate   = self
        listTable.separatorStyle = UITableViewCellSeparatorStyle.None
        listTable.bounces = false
        
//        longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "handleLongPressGesture:")
//        longPressGestureRecognizer!.numberOfTouchesRequired = 1
//        longPressGestureRecognizer!.allowableMovement = 50
//        longPressGestureRecognizer!.minimumPressDuration = 0.5
//        
//        listTable.addGestureRecognizer(longPressGestureRecognizer!)
        self.view.addSubview(listTable)
    }
    
    
    //详细列表 tableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //return listTableDataSource.count
        if flagExpense == 1 {
            return dailyExpenseDS.count
        }else {
            return dailyIncomeDS.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.registerClass(DailyTableViewCell.self, forCellReuseIdentifier: "DailyListCell")
        var cell = tableView.dequeueReusableCellWithIdentifier("DailyListCell", forIndexPath: indexPath) as? DailyTableViewCell
        if (indexPath.row%2 == 0) {
            cell?.backgroundColor = UIColor.whiteColor()
        }else{
            cell?.backgroundColor = UIColor(red: 0.94, green: 0.93, blue: 0.93, alpha: 1)
        }
        var image    = cell?.leftImageView
        var leftText = cell?.leftTextLabel
        var detail   = cell?.detailLabel
        var righText = cell?.rightTextLabel
        
        if (flagExpense == 1){
            if let imagePath = userCategoryDS.associatedImagePathFor(category: dailyExpenseDS[indexPath.row].cat){
                if defaultCategoryImages.containsObject(imagePath) {
                    image?.image = UIImage(named: imagePath)
                }else{
                    image?.image = UIImage(named: "blankCategory")
                }
            }
            leftText?.text = dailyExpenseDS[indexPath.row].cat
            detail?.text = dailyExpenseDS[indexPath.row].detl
            righText?.text = "-\(dailyExpenseDS[indexPath.row].amoStr)"
        }else{
            //image?.image = UIImage(named: "food")
            //BICategory.associatedImagePathFor("d")
            if let imagePath = userCategoryDS.associatedImagePathFor(category:dailyIncomeDS[indexPath.row].cat){
                if defaultCategoryImages.containsObject(imagePath) {
                    image?.image = UIImage(named: imagePath)
                }else{
                    image?.image = UIImage(named: "blankCategory")
                }
            }
            leftText?.text = dailyIncomeDS[indexPath.row].cat//"Cate2"
            leftText?.textColor = UIColor(red: 0.82, green: 0.47, blue: 0.43, alpha: 1)
            leftText?.font = UIFont.boldSystemFontOfSize(22)
            detail?.text = dailyIncomeDS[indexPath.row].detl
            detail?.textColor = UIColor(red: 0.53, green: 0.53, blue: 0.53, alpha: 1)
            detail?.font = UIFont.italicSystemFontOfSize(15)
            righText?.text = "+\(dailyIncomeDS[indexPath.row].amoStr)"//"+100"
            righText?.textColor = UIColor(red: 0.82, green: 0.47, blue: 0.43, alpha: 1)
            righText?.textAlignment = NSTextAlignment.Right
            righText?.font = UIFont.boldSystemFontOfSize(33)
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return bgWidth*0.24
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //listTableDataSource.removeObjectAtIndex(indexPath.row)
        if flagExpense == 1 {
            BIExpense.removeFromDatabase(expenseID: dailyExpenseDS[indexPath.row].ID)
            dailyExpenseDS = BIExpense.dailyRecords(year: selectedYear!, month: selectedMonth!, day: selectedDay!)
        }else {
            BIIncome.removeFromDatabase(incomeID: dailyIncomeDS[indexPath.row].ID)
            dailyIncomeDS = BIIncome.dailyRecords(year: selectedYear!, month: selectedMonth!, day: selectedDay!)
        }
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        naviBtnNew.removeFromSuperview()
        naviBtnBack.removeFromSuperview()
        isModificationMode = true
        isFromRootVC       = false
        var newViewController = NewViewController()
        self.navigationController?.pushViewController(newViewController, animated: true)
        if flagExpense == 0 {
            newViewController.incomeRecord = dailyIncomeDS[indexPath.row]
            newViewController.flagExpense  = false
        }else{
            newViewController.expenseRecord = dailyExpenseDS[indexPath.row]
            newViewController.flagExpense   = true
        }
    }
    
    //长按手势识别
//    func handleLongPressGesture(recognizer:UILongPressGestureRecognizer){
//        if (recognizer.state == UIGestureRecognizerState.Began){
//            listTable.setEditing(!listTable.editing, animated: true)
//            println("longPress")
//        }
//    }
    
    
    //导航栏按钮点击事件 - 不管点哪个都要移除左右两边的按钮
    func naviBtnNewTouch () {
        naviBtnNew.removeFromSuperview()
        naviBtnBack.removeFromSuperview()
        var newViewController = NewViewController()
        self.navigationController?.pushViewController(newViewController, animated: true)
        isModificationMode = false
        isFromRootVC       = false
        if flagExpense == 0 {
            newViewController.flagExpense  = false
        }else{
            newViewController.flagExpense   = true
        }
    }
    
    func naviBtnBackTouch () {
        naviBtnNew.removeFromSuperview()
        naviBtnBack.removeFromSuperview()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func tabBtnExTouch () {
        flagExpense = 1
        tabBtnEx.selected = true
        tabBtnIn.selected = false
//        tabBtnEx.backgroundColor = UIColor(red: 0.82, green: 0.43, blue: 0.37, alpha: 1)//red
//        tabBtnIn.backgroundColor = UIColor(red: 0.94, green: 0.78, blue: 0.71, alpha: 1)//pink
        listTable.reloadData()
    }
    
    func tabBtnInTouch () {
        flagExpense = 0
        tabBtnEx.selected = false
        tabBtnIn.selected = true
//        tabBtnIn.backgroundColor = UIColor(red: 0.82, green: 0.43, blue: 0.37, alpha: 1)//red
//        tabBtnEx.backgroundColor = UIColor(red: 0.94, green: 0.78, blue: 0.71, alpha: 1)//pink
        listTable.reloadData()
    }
    
    //导航－页面即将显示
    override func viewWillAppear(animated: Bool) {
        var naviLabel   = self.navigationController?.navigationBar.viewWithTag(1) as! UILabel
        naviLabel.text  = "\(selectedDay!)/\(selectedMonth!)/\(selectedYear!)"
        
        naviBtnNew  = UIButton(frame: CGRect(x: bgWidth - 70, y: bgHeight*0.015, width: 55, height: 55))
        naviBtnNew.setBackgroundImage(UIImage(named: "new"), forState: UIControlState.Normal)
        naviBtnNew.addTarget(self, action: "naviBtnNewTouch", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationController?.navigationBar.addSubview(naviBtnNew)
        
        naviBtnBack = UIButton(frame: CGRect(x: 16, y: bgHeight*0.025, width: 35, height: 35))
        naviBtnBack.setBackgroundImage(UIImage(named: "back"), forState: UIControlState.Normal)
        naviBtnBack.addTarget(self, action: "naviBtnBackTouch", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationController?.navigationBar.addSubview(naviBtnBack)
        
        dailyExpenseDS = BIExpense.dailyRecords(year: selectedYear!, month: selectedMonth!, day: selectedDay!)
        dailyIncomeDS = BIIncome.dailyRecords(year: selectedYear!, month: selectedMonth!, day: selectedDay!)
        
        self.listTable.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
