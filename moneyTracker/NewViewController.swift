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
//    var didSelectRow2 = false
var didSelectSection3 = false
var isModificationMode = false

class NewViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SmallCategoryCellDelegate,UITextFieldDelegate,UITextViewDelegate,DailyTableViewCellDelegate {
    
    var mainCollectionView: UICollectionView?
    var isFirstLoad = true
    
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
        //flowLayOut.itemSize = CGSizeMake(130, 130)
        //flowLayOut.scrollDirection = UICollectionViewScrollDirection.Vertical
        //flowLayOut.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        //flowLayOut.minimumInteritemSpacing = 10
        
        mainCollectionView = UICollectionView(frame: CGRect(x: 0, y: _naviHeight, width: bgWidth, height: collectionHeight), collectionViewLayout: flowLayOut)
        mainCollectionView!.dataSource = self
        mainCollectionView!.delegate   = self
        mainCollectionView?.backgroundColor = UIColor.clearColor()
        mainCollectionView?.tag = 0
        self.view.addSubview(mainCollectionView!)
        
        
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
                return cell!
            }else{
                cell!.backgroundColor = UIColor(red: 0.94, green: 0.93, blue: 0.93, alpha: 1)
                //判断是“新建”模式还是“修改”模式
                if (isModificationMode){
                    //cell?.datepicker?.date = 从数据库里读取
                }
                cell!.datepicker?.hidden = true
                cell!.rightLabel?.hidden = false
                if isModificationMode && isFirstLoad {
                    cell?.datepicker?.date = NSDate.dateFor(year: selectedYear!, month: selectedMonth!, day: selectedDay!)
                    isFirstLoad = false
                }
                var dt = cell?.datepicker?.date
                cell!.rightLabel?.text = NSDateFormatter.localizedStringFromDate(dt!, dateStyle: NSDateFormatterStyle.MediumStyle, timeStyle: NSDateFormatterStyle.NoStyle)

                return cell!
            }
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
                return cell!
            }else{
                cell!.backgroundColor = UIColor(red: 0.94, green: 0.93, blue: 0.93, alpha: 1)
                //判断是“新建”模式还是“修改”模式
                if (isModificationMode){
                    if (true) {
                      cell?.rightImg?.image = UIImage(named: "blankCategory")
                      cell?.rightText?.text = "小鸡炖蘑菇"
                    }else{
//                      cell?.rightImg?.image = 从数据库里读取
                    }
                }
                cell?.collectionView?.hidden = true
                cell?.rightImg?.hidden       = false
                return cell!
            }
        }
        //第三项 金额
        else if (indexPath.section == 2){
            var cell = collectionView.dequeueReusableCellWithReuseIdentifier("newAmountCell", forIndexPath: indexPath) as? NewAmountCollectionViewCell
            cell?.leftTextLabel?.text = "Amount"
            cell?.textField?.delegate = self
            //判断是“新建”模式还是“修改”模式
            if (isModificationMode){
                //cell?.textField?.text = 从数据库里读取
                cell?.textField?.text = "10000000"
            }
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
                return cell!
            }else{
                cell!.backgroundColor = UIColor(red: 0.94, green: 0.93, blue: 0.93, alpha: 1)
                cell?.textView?.hidden = true
                cell?.rightLabel?.hidden = false
                //先将 textView.text 保存至数据库，rightLabel.text从数据库调用。这样如果为新建模式，显示空字符串，如果为修改模式，显示现有的字符串
                //判断是“新建”模式还是“修改”模式
                if (isModificationMode){
                    //cell?.textView?.text = 从数据库里读取
                    cell?.textView?.text = "小鸡炖蘑菇"
                }
                cell?.rightLabel?.text = cell?.textView?.text
                return cell!
            }
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
    }
    func textViewDidBeginEditing(textView: UITextView) {
        println("textView DidBeginEditing")
        self.view.frame.origin.y -= 216
        var label = UILabel(frame: CGRect(x: 0, y: self.view.frame.height, width: bgWidth, height: 216))
        label.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(label)
    }
    func textViewDidEndEditing(textView: UITextView) {
        didSelectSection3 = false
        self.view.frame.origin.y += 216
        println("textView DidEndEditing")
    }
    
    
    //页面即将显示时
    override func viewWillAppear(animated: Bool) {
        (self.navigationController?.viewControllers[1] as! DailyViewController).delegate = self

        var naviLabel = self.navigationController?.navigationBar.viewWithTag(1) as! UILabel
        if isModificationMode {
            naviLabel.text = "Modification"
        }else{
            naviLabel.text = "New Note"
        }
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
    func naviBtnSaveTouch () {
        var naviBtnSave = self.navigationController?.navigationBar.viewWithTag(2) as! UIButton
        var naviBtnSaveImg = self.navigationController?.navigationBar.viewWithTag(3) as! UIImageView
        naviBtnSave.removeFromSuperview()
        naviBtnSaveImg.removeFromSuperview()
        self.navigationController?.popViewControllerAnimated(true)
        if isModificationMode {
            var listTable = (self.navigationController?.viewControllers[1] as! DailyViewController).listTable
            listTable.deselectRowAtIndexPath(listTable.indexPathForSelectedRow()!, animated: false)
            isModificationMode = false
        }
    }
    
    func naviBtnCancelTouch () {
        var naviBtnSave = self.navigationController?.navigationBar.viewWithTag(2) as! UIButton
        var naviBtnSaveImg = self.navigationController?.navigationBar.viewWithTag(3) as! UIImageView
        naviBtnSave.removeFromSuperview()
        naviBtnSaveImg.removeFromSuperview()
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


