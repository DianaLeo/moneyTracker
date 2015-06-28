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
var isFromRootVC = true
var category = ""

class NewViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SmallCategoryCellDelegate,CategoryViewControllerDelegate,UITextFieldDelegate,UITextViewDelegate {
    
    var mainCollectionView: UICollectionView?
    var naviLabel = UILabel()
    var btnChooseExpense = UIButton()
    var naviBtnSave   = UIButton()
    var naviBtnCancel = UIButton()
    var label = UILabel()
    var catCellRightImg  = UIImageView()
    var amoCellTextField = UITextField()
    var isFirstLoad = true
    var flagExpense = true
    var income = Income()
    var expense = Expense()
    var amount = Float()
    var detail = ""
    // class inside temp time
    var choosedYear:Int?
    var choosedMonth:Int?
    var choosedDay:Int?
    var incomeRecord: IncomeRecord?
    var expenseRecord: ExpenseRecord?
    //高度计算
    var _naviRatio = 0.15 as CGFloat
    var _naviHeight = CGFloat()
    var defaultCellHeight = CGFloat()
    var cellHeight = CGFloat()

    override func viewDidLoad() {
        super.viewDidLoad()
        //高度计算
        _naviHeight     = bgHeight * _naviRatio
        var collectionHeight = bgHeight * (1 - _naviRatio)
        var bgTransHeight    = bgHeight * (1 - _naviRatio)
        defaultCellHeight    = bgWidth*0.27
        cellHeight           = bgWidth*0.71
        
        //背景
        var bgImage = UIImageView(frame: CGRect(x: 0, y: 0, width: bgWidth, height: bgHeight))
        bgImage.image = UIImage(named: "background1")
        self.view.addSubview(bgImage)
        var bgTrans = UIImageView(frame: CGRect(x: 0, y: _naviHeight, width: bgWidth, height: bgTransHeight))
        bgTrans.image = UIImage(named: "background2")
        self.view.addSubview(bgTrans)
        self.navigationItem.hidesBackButton = true
        
        //列表 collectionView
        var flowLayOut = UICollectionViewFlowLayout()
        mainCollectionView = UICollectionView(frame: CGRect(x: 0, y: _naviHeight, width: bgWidth, height: collectionHeight), collectionViewLayout: flowLayOut)
        mainCollectionView!.dataSource = self
        mainCollectionView!.delegate   = self
        mainCollectionView?.backgroundColor = UIColor.clearColor()
        mainCollectionView?.bounces = false
        mainCollectionView?.tag = 0
        self.view.addSubview(mainCollectionView!)
        
        label = UILabel(frame: CGRect(x: 0, y: _naviHeight - defaultCellHeight*2.5 + collectionHeight, width: bgWidth, height: bgHeight*0.33))
        label.backgroundColor = UIColor.whiteColor()
        label.hidden = true
        self.view.addSubview(label)
    }
    
    //详细列表的实现
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 4
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
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
            if (didSelectSection0 == true){
                cell!.backgroundColor = UIColor.whiteColor()
                cell!.datepicker?.hidden = false
                cell!.rightLabel?.hidden = true
            }else{
                cell!.backgroundColor = UIColor(red: 0.94, green: 0.93, blue: 0.93, alpha: 1)
                cell!.datepicker?.hidden = true
                cell!.rightLabel?.hidden = false
            }
            //若为“修改”模式，或从dailyVC来的“新建”模式
            if ((isModificationMode && isFirstLoad)||(!isFromRootVC && isFirstLoad)) {
                cell?.datepicker?.date = NSDate.dateFor(year: selectedYear!, month: selectedMonth!, day: selectedDay!)
            }
            var dt = cell?.datepicker?.date
            cell?.rightLabel?.text = NSDateFormatter.localizedStringFromDate(dt!, dateStyle: NSDateFormatterStyle.MediumStyle, timeStyle: NSDateFormatterStyle.NoStyle)
            //存储
            var format = NSDateFormatter()
            format.dateFormat = "yyyyMMddhhmmss"
            var dateString = NSString(string: format.stringFromDate(dt!))
            println(dateString)
            choosedYear  = dateString.substringWithRange(NSRange(location: 0, length: 4)).toInt()
            choosedMonth = dateString.substringWithRange(NSRange(location: 4, length: 2)).toInt()
            choosedDay   = dateString.substringWithRange(NSRange(location: 6, length: 2)).toInt()
            
            return cell!
        }
        //第二项 分类
        else if (indexPath.section == 1){
            var cell = collectionView.dequeueReusableCellWithReuseIdentifier("newCategoryCell", forIndexPath: indexPath) as? NewCategoryCollectionViewCell
            cell?.delegate = self
            catCellRightImg = (cell?.rightImg)!
            if (didSelectSection1 == true){
                cell!.backgroundColor = UIColor.whiteColor()
                cell?.collectionView?.hidden = false
                cell?.rightImg?.hidden       = true
            }else{
                cell!.backgroundColor = UIColor(red: 0.94, green: 0.93, blue: 0.93, alpha: 1)
                //判断是“新建”模式还是“修改”模式
                if (isModificationMode && isFirstLoad){
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
            cell?.textField?.delegate = self
            amoCellTextField = (cell?.textField)!
            //判断是“新建”模式还是“修改”模式
            if (isModificationMode && isFirstLoad){
                if flagExpense == true {
                    cell?.textField?.text = expenseRecord?.amoStr ?? "unknown"
                }else{
                    cell?.textField?.text = incomeRecord?.amoStr ?? "unknown"
                }
            }
            return cell!
        }
        //第四项 详细内容
        else if (indexPath.section == 3){
            var cell = collectionView.dequeueReusableCellWithReuseIdentifier("newDetailCell", forIndexPath: indexPath) as? NewDetailCollectionViewCell
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
                if flagExpense == true {
                    cell?.textView?.text = expenseRecord?.detl
                }else {
                    cell?.textView?.text = incomeRecord?.detl
                }
                
            }
            if (!isFromRootVC){
                isFirstLoad = false 
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
    func didSelectLastCell (#indexPath: NSIndexPath){
        naviBtnSave.removeFromSuperview()
        naviBtnCancel.removeFromSuperview()
        if !isModificationMode {
            btnChooseExpense.removeFromSuperview()
        }
        var categoryViewController = CategoryViewController()
        categoryViewController.delegate = self
        self.navigationController?.pushViewController(categoryViewController, animated: true)
    }
    
    func categoryVCdidSelectBtnOK(#text: String) {
        var newCategoryCollectionViewCell = mainCollectionView?.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 1)) as! NewCategoryCollectionViewCell
        if !newCategoryCollectionViewCell.collectionViewDataSource.containsObject(text) {
            //如果类别列表中没有选中项
            newCategoryCollectionViewCell.userCategoryDS.choosedAssociatedImagePath = text.lowercaseString
            if newCategoryCollectionViewCell.userCategoryDS.choosedAssociatedImagePath == "luckymoney" {
                newCategoryCollectionViewCell.userCategoryDS.choosedAssociatedImagePath = "luckyMoney"
            }
            if newCategoryCollectionViewCell.userCategoryDS.choosedAssociatedImagePath == "fulltimejob" {
                newCategoryCollectionViewCell.userCategoryDS.choosedAssociatedImagePath = "fullTimeJob"
            }
            
            if newCategoryCollectionViewCell.userCategoryDS.choosedAssociatedImagePath == "parttimejob" {
                newCategoryCollectionViewCell.userCategoryDS.choosedAssociatedImagePath = "partTimeJob"
            }
            //println(userCategoryDS.choosedAssociatedImagePath)
            newCategoryCollectionViewCell.userCategoryDS.expenseCategories.append(text)
            //println(userCategoryDS.expenseCategories)
            newCategoryCollectionViewCell.collectionViewDataSource = NSMutableArray(array: newCategoryCollectionViewCell.userCategoryDS.expenseCategories)
            //println(collectionViewDataSource)
            newCategoryCollectionViewCell.collectionView!.reloadData()
        }
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
        mainCollectionView?.frame.origin.y = _naviHeight - defaultCellHeight*1
    }
    func textFieldDidEndEditing(textField: UITextField) {
        mainCollectionView?.frame.origin.y = _naviHeight
    }
    func textViewDidBeginEditing(textView: UITextView) {
        label.hidden = false
        mainCollectionView?.frame.origin.y = _naviHeight - defaultCellHeight*2.5
    }
    func textViewDidEndEditing(textView: UITextView) {
        label.hidden = true
        didSelectSection3 = false
        mainCollectionView?.frame.origin.y = _naviHeight
    }
    
    
    //页面即将显示时
    override func viewWillAppear(animated: Bool) {
        naviLabel = self.navigationController?.navigationBar.viewWithTag(1) as! UILabel
        if flagExpense{
            naviLabel.text = "Expense"
        }else{
            naviLabel.text = "Income"
        }
        
        if (isModificationMode == false){
            btnChooseExpense = UIButton(frame: CGRect(x: bgWidth/2 + 60, y: 30, width: 20, height: 20))
            btnChooseExpense.backgroundColor = UIColor.clearColor()
            var btnChooseExpenseImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            btnChooseExpenseImage.image = UIImage(named: "btnChooseExpenseImage")
            btnChooseExpense.addSubview(btnChooseExpenseImage)
            btnChooseExpense.addTarget(self, action: "btnChooseExpenseTouch", forControlEvents: UIControlEvents.TouchUpInside)
            self.navigationController?.navigationBar.addSubview(btnChooseExpense)
        }
        
        naviBtnSave = UIButton(frame: CGRect(x: bgWidth - 70, y: bgHeight*0.015, width: 55, height: 55))
        naviBtnSave.setBackgroundImage(UIImage(named: "save"), forState: UIControlState.Normal)
        naviBtnSave.addTarget(self, action: "naviBtnSaveTouch", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationController?.navigationBar.addSubview(naviBtnSave)
        
        naviBtnCancel = UIButton(frame: CGRect(x: 16, y: bgHeight*0.025, width: 40, height: 35))
        naviBtnCancel.setBackgroundImage(UIImage(named: "cancel"), forState: UIControlState.Normal)
        naviBtnCancel.addTarget(self, action: "naviBtnCancelTouch", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationController?.navigationBar.addSubview(naviBtnCancel)
    }
    
    //导航栏按钮点击事件 - 不管点哪个都要移除左右两边的按钮
    func btnChooseExpenseTouch(){
        if !isModificationMode {
            flagExpense = !flagExpense
            if flagExpense{
                naviLabel.text = "Expense"
            }else{
                naviLabel.text = "Income"
            }
        }
    }
    
    func naviBtnSaveTouch () {
        if ((catCellRightImg.image == nil)||(amoCellTextField.text == "")){
            var alert:UIAlertView? = UIAlertView(title: "Incomplete Info", message: "You can't save record without category or amount!", delegate: self, cancelButtonTitle: "Yes")
            alert!.show()
        }else{
            amount = NSString(string: ((mainCollectionView?.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 2)) as! NewAmountCollectionViewCell).textField?.text)!).floatValue
            naviBtnSave.removeFromSuperview()
            naviBtnCancel.removeFromSuperview()
            
            if isModificationMode {
                isModificationMode = false
                if flagExpense == true {
                    var newExpense = Expense(year: choosedYear!, month: choosedMonth!, day: choosedDay!, category: category, categoryDetail: nil, amount: amount, expenseDetail: detail, receiptImage: nil)
                    BIExpense.updateToDatabase(expenseID: expenseRecord!.ID, expense: newExpense)
                    
                }else{
                    var newIncome = Income(year: choosedYear!, month: choosedMonth!, day: choosedDay!, category: category, categoryDetail: nil, amount: amount, incomeDetail: detail, receiptImage: nil)
                    BIIncome.updateToDatabase(incomeID: incomeRecord!.ID, income: newIncome)
                }
            }else {
                if flagExpense{
                    BIExpense(year: choosedYear!, month: choosedMonth!, day: choosedDay!, category: category, categoryDetail: nil, amounts: amount, expenseDetail: detail, receiptImage: nil)
                }else{
                    BIIncome(year: choosedYear!, month: choosedMonth!, day: choosedDay!, category: category, categoryDetail: nil, amounts: amount, incomeDetail: detail, receiptImage: nil)
                }
                btnChooseExpense.removeFromSuperview()
            }            
            self.navigationController?.popViewControllerAnimated(true)

        }
    }
    
    func naviBtnCancelTouch () {
        naviBtnSave.removeFromSuperview()
        naviBtnCancel.removeFromSuperview()

        self.navigationController?.popViewControllerAnimated(true)
        if isModificationMode {
            var listTable = (self.navigationController?.viewControllers[1] as! DailyViewController).listTable
            listTable.deselectRowAtIndexPath(listTable.indexPathForSelectedRow()!, animated: false)
            isModificationMode = false
        }else{
            btnChooseExpense.removeFromSuperview()
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


