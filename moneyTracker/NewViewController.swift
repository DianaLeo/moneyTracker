//
//  NewTableViewController.swift
//  moneyTracker
//
//  Created by User on 25/05/2015.
//  Copyright (c) 2015 User. All rights reserved.
//


//备注：代码实现flow layout太尼玛烦了！注意两个全局变量（collectionview & flowlayout）的初始化方法。
//备注：打开键盘的方法 ⌘K； 批量修改变量名； 自定义函数传参; uilabel文字换行显示
//备注：改变模态窗口大小的两种方法（on completion & 背景设透明）但两个view controller不能同时存在，所以还得用添加subview的方式;返回时取消上一界面cell的选种状态；

import UIKit

var didSelectSection0 = false
var didSelectSection1 = false
var didSelectSection3 = false
var isModificationMode = false
var category = ""

var choosedYear = selectedYear
var choosedMonth = selectedMonth
var choosedDay = selectedDay
class NewViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SmallCategoryCellDelegate,UITextFieldDelegate,UITextViewDelegate,DailyTableViewCellDelegate {
    
    var mainCollectionView: UICollectionView?
    var naviLabel = UILabel()
    var btnChooseExpense = UIButton()
    var label = UILabel()
    var isFirstLoad = true
    var flagExpense = true
    var income = Income()
    var expense = Expense()
    var amount = Float()
    var detail = ""
    // class inside temp time
    var selectedYear:Int?
    var selectedMonth:Int?
    var selectedDay:Int?
    //incomeRecord and expenseRecord
    var incomeRecord: IncomeRecord?
    var expenseRecord: ExpenseRecord?
    //高度计算
    var bgWidth  = UIScreen.mainScreen().bounds.size.width
    var bgHeight = UIScreen.mainScreen().bounds.size.height
    var _naviRatio = 0.15 as CGFloat

    override func viewDidLoad() {
        super.viewDidLoad()
        var _naviHeight     = bgHeight * _naviRatio
        var collectionHeight     = bgHeight * (1 - _naviRatio)
        var bgTransHeight   = bgHeight * (1 - _naviRatio)
        
        //背景
        var bgImage = UIImageView(frame: CGRect(x: 0, y: 0, width: bgWidth, height: bgHeight))
        bgImage.image = UIImage(named: "background1")
        self.view.addSubview(bgImage)
        var bgTrans = UIImageView(frame: CGRect(x: 0, y: _naviHeight, width: bgWidth, height: bgTransHeight))
        bgTrans.image = UIImage(named: "background2")
        self.view.addSubview(bgTrans)
        
        //列表 collectionView
        var flowLayOut = UICollectionViewFlowLayout()
        mainCollectionView = UICollectionView(frame: CGRect(x: 0, y: _naviHeight, width: bgWidth, height: collectionHeight), collectionViewLayout: flowLayOut)
        mainCollectionView!.dataSource = self
        mainCollectionView!.delegate   = self
        mainCollectionView?.backgroundColor = UIColor.clearColor()
        mainCollectionView?.tag = 0
        self.view.addSubview(mainCollectionView!)
        
        label = UILabel(frame: CGRect(x: 0, y: self.view.frame.height, width: bgWidth, height: 216))
        label.backgroundColor = UIColor.whiteColor()
        label.hidden = true
        self.view.addSubview(label)
    }
    
    func passRecordID(#recordID: Int) {
        println("\(recordID)")
    }
    
    //详细列表的实现
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 4
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var defaultCellHeight = 100 as CGFloat
        var cellHeight = bgHeight*(1 - _naviRatio) - defaultCellHeight*3
        
        if (indexPath.section == 0) && (didSelectSection0 == true) {
            return CGSize(width: bgWidth, height: cellHeight)
        }
        else if (indexPath.section == 1) && (didSelectSection1 == true) {
            return CGSize(width: bgWidth, height: cellHeight)
        }
        else if (indexPath.section == 3) && (didSelectSection3 == true) {
            return CGSize(width: bgWidth, height: cellHeight)
        }
        else {
            return CGSize(width: bgWidth, height: defaultCellHeight)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 0){
            didSelectSection0 = !didSelectSection0
            didSelectSection1 = false
            didSelectSection3 = false
        }else if(indexPath.section == 1){
            didSelectSection1 = !didSelectSection1
            didSelectSection0 = false
            didSelectSection3 = false
        }else if(indexPath.section == 2){
            didSelectSection1 = false
            didSelectSection0 = false
            didSelectSection3 = false
        }else if(indexPath.section == 3){
            didSelectSection3 = !didSelectSection3
            didSelectSection0 = false
            didSelectSection1 = false
        }
        collectionView.reloadData()
//        var popupWin = PopupViewController()
//        popupWin.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
//        popupWin.modalPresentationStyle = UIModalPresentationStyle.FormSheet
//        self.navigationController?.presentViewController(popupWin, animated: true, completion: { () -> Void in
//            popupWin.view.superview?.frame = CGRectMake(100, 100, 200, 200)
//        })
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        collectionView.registerClass(NewDateCollectionViewCell.self, forCellWithReuseIdentifier: "newDateCell")
        collectionView.registerClass(NewCategoryCollectionViewCell.self, forCellWithReuseIdentifier: "newCategoryCell")
        collectionView.registerClass(NewAmountCollectionViewCell.self, forCellWithReuseIdentifier: "newAmountCell")
        collectionView.registerClass(NewDetailCollectionViewCell.self, forCellWithReuseIdentifier: "newDetailCell")
        //第一项 日期选择
        if (indexPath.section == 0){
            var cell = collectionView.dequeueReusableCellWithReuseIdentifier("newDateCell", forIndexPath: indexPath) as? NewDateCollectionViewCell
            cell!.leftTextLabel?.text = "Datepicker"
            if (didSelectSection0 == true){
                cell!.backgroundColor = UIColor.whiteColor()
                cell!.datepicker?.hidden = false
                cell!.rightLabel?.hidden = true
            }else{
                cell!.backgroundColor = UIColor(red: 0.94, green: 0.93, blue: 0.93, alpha: 1)
                cell!.datepicker?.hidden = true
                cell!.rightLabel?.hidden = false
            }
            //判断是“修改”模式还是“新建”模式
            if isModificationMode && isFirstLoad {
                println("cell0: isfirstload?\(isFirstLoad)")
                cell?.datepicker?.date = NSDate.dateFor(year: choosedYear!, month: choosedMonth!, day: choosedDay!)
            }
            var dt = cell?.datepicker?.date
            cell?.rightLabel?.text = NSDateFormatter.localizedStringFromDate(dt!, dateStyle: NSDateFormatterStyle.MediumStyle, timeStyle: NSDateFormatterStyle.NoStyle)
            //存储
            var format = NSDateFormatter()
            var format2 = NSDateFormatter()
            format.dateFormat = "yyyyMMddhhmmss"
            //format.dateStyle = NSDateFormatterStyle.ShortStyle
            var dateString = NSString(string: format.stringFromDate(dt!))
            println(dateString)
            self.selectedYear  = dateString.substringWithRange(NSRange(location: 0, length: 4)).toInt()
            self.selectedMonth = dateString.substringWithRange(NSRange(location: 4, length: 2)).toInt()
            self.selectedDay   = dateString.substringWithRange(NSRange(location: 6, length: 2)).toInt()
            
            return cell!
        }
        //第二项 分类
        else if (indexPath.section == 1){
            var cell = collectionView.dequeueReusableCellWithReuseIdentifier("newCategoryCell", forIndexPath: indexPath) as? NewCategoryCollectionViewCell
            cell?.delegate = self
            cell?.leftTextLabel?.text = "Category"
            if (didSelectSection1 == true){
                cell!.backgroundColor = UIColor.whiteColor()
                cell?.collectionView?.hidden = false
                cell?.rightImg?.hidden       = true
            }else{
                cell!.backgroundColor = UIColor(red: 0.94, green: 0.93, blue: 0.93, alpha: 1)
                //判断是“新建”模式还是“修改”模式
                if (isModificationMode && isFirstLoad){
                    println("cell1: isfirstload?\(isFirstLoad)")
                    var userCategoryDS = BICategory.sharedInstance()
                    if flagExpense == true {
                        if let expCat = expenseRecord?.cat{
                            if let imagePath = userCategoryDS.associatedImagePathFor(category: expenseRecord!.cat){
                                cell?.rightImg?.image = UIImage(named: imagePath)
                                cell?.rightText?.text = ""
                            }
                        }else{
                            cell?.rightImg?.image = UIImage(named: "blankCategory")
                            cell?.rightText?.text = expenseRecord?.cat
                        }
                        category = expenseRecord?.cat ?? ""
                    }else{
                        if let incCat = incomeRecord?.cat{
                            if let imagePath = userCategoryDS.associatedImagePathFor(category: incomeRecord!.cat){
                                cell?.rightImg?.image = UIImage(named: imagePath)
                                cell?.rightText?.text = ""
                            }
                        }else{
                            cell?.rightImg?.image = UIImage(named: "blankCategory")
                            cell?.rightText?.text = incomeRecord?.cat
                        }
                        category = incomeRecord?.cat ?? ""
                    }
                }
                cell?.collectionView?.hidden = true
                cell?.rightImg?.hidden       = false
            }
            return cell!
        }
        //第三项 金额
        else if (indexPath.section == 2){
            var cell = collectionView.dequeueReusableCellWithReuseIdentifier("newAmountCell", forIndexPath: indexPath) as? NewAmountCollectionViewCell
            cell?.leftTextLabel?.text = "Amount"
            cell?.textField?.delegate = self
            //判断是“新建”模式还是“修改”模式
            if (isModificationMode && isFirstLoad){
                println("cell2: isfirstload?\(isFirstLoad)")
                if flagExpense == true {
                    cell?.textField?.text = expenseRecord?.amoStr ?? "unknown"
                }else{
                    cell?.textField?.text = incomeRecord?.amoStr ?? "unknown"
                }
            }
            amount = NSString(string: (cell?.textField?.text)!).floatValue
            return cell!
        }
        //第四项 详细内容
        else if (indexPath.section == 3){
            var cell = collectionView.dequeueReusableCellWithReuseIdentifier("newDetailCell", forIndexPath: indexPath) as? NewDetailCollectionViewCell
            cell?.leftTextLabel?.text = "Detail"
            cell?.textView?.delegate = self
            if (didSelectSection3 == true){
                cell!.backgroundColor = UIColor.whiteColor()
                cell?.textView?.hidden = false
                cell?.rightLabel?.hidden = true
            }else{
                cell!.backgroundColor = UIColor(red: 0.94, green: 0.93, blue: 0.93, alpha: 1)
                cell?.textView?.hidden = true
                cell?.rightLabel?.hidden = false
            }
            //判断是“新建”模式还是“修改”模式
            if (isModificationMode && isFirstLoad){
                isFirstLoad = false
                println("cell3: isfirstload?\(isFirstLoad)")
                //cell?.textView?.text = 从数据库里读取
                if flagExpense == true {
                    cell?.textView?.text = expenseRecord?.detl
                }else {
                    cell?.textView?.text = incomeRecord?.detl
                }
                
            }
            cell?.rightLabel?.text = cell?.textView?.text
            detail = (cell?.textView?.text)!
            return cell!
        }

        return UICollectionViewCell()

    }
    
    //自定义代理 SmallCategoryCellDelegate 方法实现
    func didSelectSmallCell (#indexPath: NSIndexPath){
        mainCollectionView?.reloadData()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        println("textField DidBeginEditing")
        if didSelectSection0 {
            didSelectSection0 = false
            mainCollectionView?.reloadSections(NSIndexSet(index: 0))
        }
        if didSelectSection1 {
            didSelectSection1 = false
            mainCollectionView?.reloadSections(NSIndexSet(index: 1))
        }
        if didSelectSection3 {
            didSelectSection3 = false
            mainCollectionView?.reloadSections(NSIndexSet(index: 3))
        }
    }
    func textFieldDidEndEditing(textField: UITextField) {
        println("textField DidEndEditing")
        label.hidden = true
    }
    func textViewDidBeginEditing(textView: UITextView) {
        println("textView DidBeginEditing")
        self.view.frame.origin.y -= 216
        label.hidden = false
    }
    func textViewDidEndEditing(textView: UITextView) {
        didSelectSection3 = false
        self.view.frame.origin.y += 216
        println("textView DidEndEditing")
    }
    
    
    //页面即将显示时
    override func viewWillAppear(animated: Bool) {
        (self.navigationController?.viewControllers[1] as! DailyViewController).delegate = self

        naviLabel = self.navigationController?.navigationBar.viewWithTag(1) as! UILabel
        if flagExpense{
            naviLabel.text = "Expense"
        }else{
            naviLabel.text = "Income"
        }
        
        btnChooseExpense = UIButton(frame: CGRect(x: bgWidth/2 + 100, y: 20, width: 20, height: 20))
        btnChooseExpense.backgroundColor = UIColor.whiteColor()
        btnChooseExpense.addTarget(self, action: "btnChooseExpenseTouch", forControlEvents: UIControlEvents.TouchUpInside)
        btnChooseExpense.tag = 4
        self.navigationController?.navigationBar.addSubview(btnChooseExpense)
        
        var naviBtnSaveRect = CGRect(x: bgWidth - 70, y: 10, width: 55, height: 55)
        var naviBtnSave     = UIButton(frame: naviBtnSaveRect)
        var naviBtnSaveImg  = UIImageView(frame: naviBtnSaveRect)
        naviBtnSaveImg.image = UIImage(named: "save")
        naviBtnSave.addSubview(naviBtnSaveImg)
        naviBtnSave.addTarget(self, action: "naviBtnSaveTouch", forControlEvents: UIControlEvents.TouchUpInside)
        naviBtnSave.tag    = 2
        naviBtnSaveImg.tag = 3
        self.navigationController?.navigationBar.addSubview(naviBtnSave)
        self.navigationController?.navigationBar.addSubview(naviBtnSaveImg)
        
        var naviBtnCancelRect  = CGRect(x: 0, y: 10, width: 40, height: 35)
        var naviBtnCancel      = UIButton(frame: naviBtnCancelRect)
        var naviBtnCancelImg   = UIImageView(frame: naviBtnCancelRect)
        naviBtnCancelImg.image = UIImage(named: "cancel")
        naviBtnCancel.addSubview(naviBtnCancelImg)
        naviBtnCancel.addTarget(self, action: "naviBtnCancelTouch", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: naviBtnCancel)
    }
    
    //导航栏按钮点击事件 - 不管点哪个都要移除右边的按钮，而左边的按钮自动移除
    func btnChooseExpenseTouch(){
        flagExpense = !flagExpense
        if flagExpense{
            naviLabel.text = "Expense"
        }else{
            naviLabel.text = "Income"
        }
    }
    
    func naviBtnSaveTouch () {
//        println(self.selectedYear)
//        println(self.selectedMonth)
//        println(self.selectedDay)
//        println(category)
//        println(amount)
        amount = NSString(string: ((mainCollectionView?.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 2)) as! NewAmountCollectionViewCell).textField?.text)!).floatValue
        var naviBtnSave = self.navigationController?.navigationBar.viewWithTag(2) as! UIButton
        var naviBtnSaveImg = self.navigationController?.navigationBar.viewWithTag(3) as! UIImageView
        var btnChooseExpense = self.navigationController?.navigationBar.viewWithTag(4) as! UIButton
        naviBtnSave.removeFromSuperview()
        naviBtnSaveImg.removeFromSuperview()
        btnChooseExpense.removeFromSuperview()
        
        self.navigationController?.popViewControllerAnimated(true)
        if isModificationMode {
//            var listTable = (self.navigationController?.viewControllers[1] as! DailyViewController).listTable
//            listTable.deselectRowAtIndexPath(listTable.indexPathForSelectedRow()!, animated: false)
            isModificationMode = false
            if flagExpense == true {
                var newExpense = Expense(year: self.selectedYear!, month: selectedMonth!, day: self.selectedDay!, category: category, categoryDetail: nil, amount: amount, expenseDetail: detail, receiptImage: nil)
                BIExpense.updateToDatabase(expenseID: expenseRecord!.ID, expense: newExpense)
            }else{
                var newIncome = Income(year: self.selectedYear!, month: selectedMonth!, day: self.selectedDay!, category: category, categoryDetail: nil, amount: amount, incomeDetail: detail, receiptImage: nil)
                BIIncome.updateToDatabase(incomeID: incomeRecord!.ID, income: newIncome)
            }
        }else {
            if flagExpense{
                BIExpense(year: self.selectedYear!, month: self.selectedMonth!, day: self.selectedDay!, category: category, categoryDetail: nil, amounts: amount, expenseDetail: detail, receiptImage: nil)
            }else{
                BIIncome(year: self.selectedYear!, month: self.selectedMonth!, day: self.selectedDay!, category: category, categoryDetail: nil, amounts: amount, incomeDetail: detail, receiptImage: nil)
            }
        }
    }
    
    func naviBtnCancelTouch () {
        var naviBtnSave = self.navigationController?.navigationBar.viewWithTag(2) as! UIButton
        var naviBtnSaveImg = self.navigationController?.navigationBar.viewWithTag(3) as! UIImageView
        var btnChooseExpense = self.navigationController?.navigationBar.viewWithTag(4) as! UIButton
        naviBtnSave.removeFromSuperview()
        naviBtnSaveImg.removeFromSuperview()
        btnChooseExpense.removeFromSuperview()

        self.navigationController?.popViewControllerAnimated(true)
        if isModificationMode {
            var listTable = (self.navigationController?.viewControllers[1] as! DailyViewController).listTable
            listTable.deselectRowAtIndexPath(listTable.indexPathForSelectedRow()!, animated: false)
            isModificationMode = false
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
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}


