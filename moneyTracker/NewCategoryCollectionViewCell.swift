//
//  NewCategoryCollectionViewCell.swift
//  moneyTracker
//
//  Created by User on 26/05/2015.
//  Copyright (c) 2015 User. All rights reserved.
//

import UIKit

protocol SmallCategoryCellDelegate :class {
    func didSelectSmallCell (#indexPath: NSIndexPath)
}

class NewCategoryCollectionViewCell: NewCollectionViewCell,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,LongPressDelegate,UITextFieldDelegate {
    
    var collectionViewDataSource = NSMutableArray()
    var userCategoryDS = BICategory.sharedInstance()
    
    var rightImg: UIImageView?
    var rightText: UILabel?
    var flowLayOut = UICollectionViewFlowLayout()
    var collectionView: UICollectionView?
    weak var delegate: SmallCategoryCellDelegate?
    var popupWin = UIButton()
    var transpBG = UILabel()
    var textFiled = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // category
        self.collectionViewDataSource = NSMutableArray(array: userCategoryDS.expenseCategories)
        println("new category cell init")
        
        var defaultCellHeight = 100 as CGFloat
        var cellHeight = bgHeight * (1 - 0.15) - defaultCellHeight * 3
        var smallCellW = bgWidth*0.21 as CGFloat
        var smallCellH = bgWidth*0.26 as CGFloat
        
        leftTextLabel?.text = "Category"
        rightImg = UIImageView(frame: CGRect(x: bgWidth - 80 - 45, y: 10, width: smallCellW, height: smallCellW))
        rightText = UILabel(frame: CGRect(x: bgWidth - 65 - 45, y: 25, width: 50, height: 50))
        rightText!.textColor = UIColor.whiteColor()
        rightText!.textAlignment = NSTextAlignment.Center
        rightText?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        rightText?.numberOfLines = 0
        
        flowLayOut.itemSize = CGSize(width: smallCellW, height: smallCellH)
        flowLayOut.minimumInteritemSpacing = 0
        flowLayOut.minimumLineSpacing = 0
        flowLayOut.scrollDirection = UICollectionViewScrollDirection.Vertical
        collectionView = UICollectionView(frame: CGRect(x: 20, y: 60, width: bgWidth - 40, height: 200), collectionViewLayout: flowLayOut)
        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.dataSource = self
        collectionView?.delegate   = self
        
        self.addSubview(rightImg!)
        self.addSubview(rightText!)
        self.addSubview(collectionView!)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewDataSource.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        collectionView.registerClass(NewCategotyCell.self, forCellWithReuseIdentifier: "newDateCell")
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("newDateCell", forIndexPath: indexPath) as! NewCategotyCell
        cell.delegate = self
        //最后一个icon始终为“新建”
        if (indexPath.row == collectionViewDataSource.count) {
            cell.img?.image = UIImage(named: "newCategory")
            cell.label?.text = "New"
        }else{
            if let imagePath = userCategoryDS.associatedImagePathFor(category: userCategoryDS.expenseCategories[indexPath.row]) {
                //println(userCategoryDS.expenseCategories)
                cell.img?.image = UIImage(named: "\(imagePath)")
            }
            if (cell.img?.image == nil){
                cell.img?.image = UIImage(named: "blankCategory")
            }
            cell.label?.text = "\(collectionViewDataSource[indexPath.row])"
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //点击添加新Category时：
        if (indexPath.row == collectionViewDataSource.count){
            transpBG = UILabel(frame: CGRect(x: 0, y: 0, width: bgWidth, height: bgHeight))
            transpBG.backgroundColor = UIColor(white: 0, alpha: 0.4)
            
            popupWin = UIButton(frame: CGRect(x: bgWidth*0.04, y: bgWidth*0.267, width: bgWidth*0.92, height: bgWidth*0.93))
            popupWin.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
            popupWin.addTarget(self, action: "popupWinTouched", forControlEvents: UIControlEvents.TouchDown)
            
            var title = UILabel(frame: CGRect(x: 0, y: 10, width: bgWidth - 30, height: 30))
            title.text = "New Category"
            title.textAlignment = NSTextAlignment.Center
            title.textColor = UIColor.darkGrayColor()
            title.font = UIFont.boldSystemFontOfSize(20)
            
            var tip1 = UILabel(frame: CGRect(x: 8, y: 42, width: bgWidth - 30, height: 30))
            tip1.text = "Pick one from the following:"
            tip1.textColor = UIColor.darkGrayColor()
            tip1.font = UIFont.systemFontOfSize(17)
            
            var icW = bgWidth*0.214  //icon 位置
            var icH = bgWidth*0.214
            var icY = bgWidth*0.187
            var txH = bgWidth*0.05
            var txY = icH - bgWidth*0.02
            var btnW = bgWidth*0.23
            var btnH = icH + txH - bgWidth*0.02
            var img1 = UIImageView(frame: CGRect(x:0, y: 0, width: icW, height: icH))
            var img2 = UIImageView(frame: CGRect(x:0, y: 0, width: icW, height: icH))
            var img3 = UIImageView(frame: CGRect(x:0, y: 0, width: icW, height: icH))
            var img4 = UIImageView(frame: CGRect(x:0, y: 0, width: icW, height: icH))
            var img5 = UIImageView(frame: CGRect(x:0, y: 0, width: icW, height: icH))
            var img6 = UIImageView(frame: CGRect(x:0, y: 0, width: icW, height: icH))
            var img7 = UIImageView(frame: CGRect(x:0, y: 0, width: icW, height: icH))
            var img8 = UIImageView(frame: CGRect(x:0, y: 0, width: icW, height: icH))
            var txt1 = UILabel(frame: CGRect(x:0, y: txY, width: btnW, height: txH))
            var txt2 = UILabel(frame: CGRect(x:0, y: txY, width: btnW, height: txH))
            var txt3 = UILabel(frame: CGRect(x:0, y: txY, width: btnW, height: txH))
            var txt4 = UILabel(frame: CGRect(x:0, y: txY, width: btnW, height: txH))
            var txt5 = UILabel(frame: CGRect(x:0, y: txY, width: btnW, height: txH))
            var txt6 = UILabel(frame: CGRect(x:0, y: txY, width: btnW, height: txH))
            var txt7 = UILabel(frame: CGRect(x:0, y: txY, width: btnW, height: txH))
            var txt8 = UILabel(frame: CGRect(x:0, y: txY, width: btnW, height: txH))
            var btn1 = UIButton(frame: CGRect(x:btnW*0, y: icY, width: btnW, height: btnH))
            var btn2 = UIButton(frame: CGRect(x:btnW*1, y: icY, width: btnW, height: btnH))
            var btn3 = UIButton(frame: CGRect(x:btnW*2, y: icY, width: btnW, height: btnH))
            var btn4 = UIButton(frame: CGRect(x:btnW*3, y: icY, width: btnW, height: btnH))
            var btn5 = UIButton(frame: CGRect(x:btnW*0, y: icY + btnH, width: btnW, height: btnH))
            var btn6 = UIButton(frame: CGRect(x:btnW*1, y: icY + btnH, width: btnW, height: btnH))
            var btn7 = UIButton(frame: CGRect(x:btnW*2, y: icY + btnH, width: btnW, height: btnH))
            var btn8 = UIButton(frame: CGRect(x:btnW*3, y: icY + btnH, width: btnW, height: btnH))
            
            img1.image = UIImage(named: "entertainment")
            img2.image = UIImage(named: "grocery")
            img3.image = UIImage(named: "communication")
            img4.image = UIImage(named: "luxury")
            img5.image = UIImage(named: "gift")
            img6.image = UIImage(named: "health")
            img7.image = UIImage(named: "makeup")
            img8.image = UIImage(named: "luckyMoney")
            txt1.text = "Entertainment"; txt1.textColor = UIColor.grayColor(); txt1.tag = 1
            txt2.text = "Grocery";       txt2.textColor = UIColor.grayColor(); txt2.tag = 1
            txt3.text = "Communication"; txt3.textColor = UIColor.grayColor(); txt3.tag = 1
            txt4.text = "Luxury";        txt4.textColor = UIColor.grayColor(); txt4.tag = 1
            txt5.text = "Gift";          txt5.textColor = UIColor.grayColor(); txt5.tag = 1
            txt6.text = "Health";        txt6.textColor = UIColor.grayColor(); txt6.tag = 1
            txt7.text = "Makeup";        txt7.textColor = UIColor.grayColor(); txt7.tag = 1
            txt8.text = "LuckyMoney";    txt8.textColor = UIColor.grayColor(); txt8.tag = 1
            txt1.textAlignment = NSTextAlignment.Center; txt1.font = UIFont.systemFontOfSize(13)
            txt2.textAlignment = NSTextAlignment.Center; txt2.font = UIFont.systemFontOfSize(13)
            txt3.textAlignment = NSTextAlignment.Center; txt3.font = UIFont.systemFontOfSize(13)
            txt4.textAlignment = NSTextAlignment.Center; txt4.font = UIFont.systemFontOfSize(13)
            txt5.textAlignment = NSTextAlignment.Center; txt5.font = UIFont.systemFontOfSize(13)
            txt6.textAlignment = NSTextAlignment.Center; txt6.font = UIFont.systemFontOfSize(13)
            txt7.textAlignment = NSTextAlignment.Center; txt7.font = UIFont.systemFontOfSize(13)
            txt8.textAlignment = NSTextAlignment.Center; txt8.font = UIFont.systemFontOfSize(13)
            
            btn1.addTarget(self, action: "iconTouch:", forControlEvents: UIControlEvents.TouchUpInside)
            btn2.addTarget(self, action: "iconTouch:", forControlEvents: UIControlEvents.TouchUpInside)
            btn3.addTarget(self, action: "iconTouch:", forControlEvents: UIControlEvents.TouchUpInside)
            btn4.addTarget(self, action: "iconTouch:", forControlEvents: UIControlEvents.TouchUpInside)
            btn5.addTarget(self, action: "iconTouch:", forControlEvents: UIControlEvents.TouchUpInside)
            btn6.addTarget(self, action: "iconTouch:", forControlEvents: UIControlEvents.TouchUpInside)
            btn7.addTarget(self, action: "iconTouch:", forControlEvents: UIControlEvents.TouchUpInside)
            btn8.addTarget(self, action: "iconTouch:", forControlEvents: UIControlEvents.TouchUpInside)
            
            var tip2 = UILabel(frame: CGRect(x: 8, y: bgWidth*0.7, width: bgWidth - 30, height: 30))
            tip2.text = "Or create your own:"
            tip2.textColor = UIColor.darkGrayColor()
            tip2.font = UIFont.systemFontOfSize(17)
            
            textFiled = UITextField(frame: CGRect(x: bgWidth*0.053, y: bgWidth*0.8, width: bgWidth*0.53, height: 30))
            textFiled.borderStyle = UITextBorderStyle.RoundedRect
            textFiled.delegate = self
            var btnOK  = UIButton(frame: CGRect(x:bgWidth*0.65, y: bgWidth*0.8, width: bgWidth*0.22, height: 30))
            btnOK.backgroundColor  = UIColor(red: 0.82, green: 0.43, blue: 0.37, alpha: 1)
            btnOK.setTitle("Add", forState: UIControlState.Normal)
            btnOK.addTarget(self, action: "popupBtnTouch", forControlEvents: UIControlEvents.TouchUpInside)
            var btnCancel  = UIButton(frame: CGRect(x:10, y: 10, width: 28, height: 28))
            btnCancel.setBackgroundImage(UIImage(named: "popupCancel"), forState: UIControlState.Normal)
            btnCancel.addTarget(self, action: "popupCancel", forControlEvents: UIControlEvents.TouchUpInside)
            
            btn1.addSubview(img1); btn1.addSubview(txt1)
            btn2.addSubview(img2); btn2.addSubview(txt2)
            btn3.addSubview(img3); btn3.addSubview(txt3)
            btn4.addSubview(img4); btn4.addSubview(txt4)
            btn5.addSubview(img5); btn5.addSubview(txt5)
            btn6.addSubview(img6); btn6.addSubview(txt6)
            btn7.addSubview(img7); btn7.addSubview(txt7)
            btn8.addSubview(img8); btn8.addSubview(txt8)
            popupWin.addSubview(title)
            popupWin.addSubview(tip1)
            popupWin.addSubview(tip2)
            popupWin.addSubview(btn1)
            popupWin.addSubview(btn2)
            popupWin.addSubview(btn3)
            popupWin.addSubview(btn4)
            popupWin.addSubview(btn5)
            popupWin.addSubview(btn6)
            popupWin.addSubview(btn7)
            popupWin.addSubview(btn8)
            popupWin.addSubview(textFiled)
            popupWin.addSubview(btnOK)
            popupWin.addSubview(btnCancel)
            self.superview?.superview!.addSubview(transpBG)
            self.superview?.superview!.addSubview(popupWin)//将弹窗添加到NewViewController
            self.superview?.userInteractionEnabled = false//大CollectionView不能用，但是Controller能用，所以弹窗是能用的
            
        }else{
            rightImg?.image = UIImage(named: "\(collectionViewDataSource[indexPath.row])")
            if let imagePath = userCategoryDS.associatedImagePathFor(category: userCategoryDS.expenseCategories[indexPath.row]){
                rightImg?.image = UIImage(named: "\(imagePath)")
            }
            if (rightImg?.image == nil){
                rightImg?.image = UIImage(named: "blankCategory")
                rightText!.text = "\(collectionViewDataSource[indexPath.row])"
            }
            category = collectionViewDataSource[indexPath.row] as! String
            didSelectSection1 = false
            self.delegate?.didSelectSmallCell(indexPath: indexPath)
        }
    }
    
    //小弹窗内部功能
    func iconTouch(sender: UIButton){
        var txtLabel = sender.viewWithTag(1) as! UILabel
        textFiled.text = txtLabel.text
        textFiled.endEditing(true)
    }
    
    func popupBtnTouch (){
        var text = textFiled.text
        if (text == ""){
            println("no input")
        }else{
            //如果类别列表中没有选中项
            //            if !collectionViewDataSource.containsObject(text) {
            //                collectionViewDataSource.addObject(text)
            //                println("\(collectionViewDataSource)")
            //                collectionView!.reloadData()
            //            }
            if !collectionViewDataSource.containsObject(text) {
                
                userCategoryDS.choosedAssociatedImagePath = text.lowercaseString
                if userCategoryDS.choosedAssociatedImagePath == "luckymoney" {
                    userCategoryDS.choosedAssociatedImagePath = "luckyMoney"
                }
                //println(userCategoryDS.choosedAssociatedImagePath)
                userCategoryDS.expenseCategories.append(text)
                //println(userCategoryDS.expenseCategories)
                collectionViewDataSource = NSMutableArray(array: userCategoryDS.expenseCategories)
                //println(collectionViewDataSource)
                collectionView!.reloadData()
            }
            //如果已经包含选中项，则什么都不做
        }
        popupWin.removeFromSuperview()
        transpBG.removeFromSuperview()
        self.superview?.userInteractionEnabled = true
    }
    
    func popupCancel(){
        popupWin.removeFromSuperview()
        transpBG.removeFromSuperview()
        self.superview?.userInteractionEnabled = true
    }
    
    func popupWinTouched(){
        textFiled.endEditing(true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        popupWin.frame.origin.y = bgHeight - 250 - bgWidth*0.93
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        popupWin.frame.origin.y = bgWidth*0.267
    }

    
    //自定义代理 LongPressDelegate 方法实现
    func passSmallCellText(#smallCellText: String) {
        collectionViewDataSource.indexOfObject(smallCellText)
        userCategoryDS.expenseCategories.removeAtIndex(collectionViewDataSource.indexOfObject(smallCellText))
        collectionViewDataSource = NSMutableArray(array: userCategoryDS.expenseCategories)
        collectionView?.reloadData()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        println("new category collection view cell deinit")
    }
}
