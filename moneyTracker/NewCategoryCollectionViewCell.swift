//
//  NewCategoryCollectionViewCell.swift
//  moneyTracker
//
//  Created by User on 26/05/2015.
//  Copyright (c) 2015 User. All rights reserved.
//

import UIKit

protocol SmallCategoryCellDelegate {
    func didSelectSmallCell (#indexPath: NSIndexPath)
}

class NewCategoryCollectionViewCell: NewCollectionViewCell,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,LongPressDelegate {
    
    var collectionViewDataSource = NSMutableArray(array: ["clothing","food","accomontation","transport","entertainment","grocery","luxury"])
    
    var rightImg: UIImageView?
    var rightText: UILabel?
    var flowLayOut = UICollectionViewFlowLayout()
    var collectionView: UICollectionView?
    var delegate: SmallCategoryCellDelegate?
    var popupWin = UIView()
    var transpBG = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        var defaultCellHeight = 100 as CGFloat
        var cellHeight = bgHeight * (1 - 0.15) - defaultCellHeight * 3
        var smallCellW = 80 as CGFloat
        var smallCellH = 100 as CGFloat
    
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
            cell.label?.text = "newCategory"
        }else{
            cell.img?.image = UIImage(named: "\(collectionViewDataSource[indexPath.row])")
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
            transpBG.backgroundColor = UIColor(white: 0.2, alpha: 0.3)
            
            popupWin = UIView(frame: CGRect(x: 15, y: 100, width: bgWidth - 30, height: 350))
            
            var lab = UILabel(frame: CGRect(x: 0, y: 0, width: bgWidth - 30, height: 350))
            lab.backgroundColor = UIColor(red: 1, green: 0.9, blue: 0.9, alpha: 1)
            
            var title = UILabel(frame: CGRect(x: 0, y: 15, width: bgWidth - 30, height: 30))
            title.text = "New Category"
            title.font = UIFont.boldSystemFontOfSize(20)
            title.textAlignment = NSTextAlignment.Center
            
            var tip1 = UILabel(frame: CGRect(x: 8, y: 45, width: bgWidth - 30, height: 30))
            tip1.text = "Please pick one from the following:"
            tip1.font = UIFont.systemFontOfSize(17)
            
            var icW = 80  //icon 位置
            var icH = 80
            var icY = 70
            var txH = 20
            var txY = icY + icH - 10
            var btnH = icH + txH
            var btnOK  = UIButton(frame: CGRect(x:220, y: 300, width: 80, height: 30))
            var img1 = UIImageView(frame: CGRect(x:0, y: 0, width: icW, height: icH))
            var img2 = UIImageView(frame: CGRect(x:0, y: 0, width: icW, height: icH))
            var img3 = UIImageView(frame: CGRect(x:0, y: 0, width: icW, height: icH))
            var img4 = UIImageView(frame: CGRect(x:0, y: 0, width: icW, height: icH))
            var img5 = UIImageView(frame: CGRect(x:0, y: 0, width: icW, height: icH))
            var img6 = UIImageView(frame: CGRect(x:0, y: 0, width: icW, height: icH))
            var img7 = UIImageView(frame: CGRect(x:0, y: 0, width: icW, height: icH))
            var img8 = UIImageView(frame: CGRect(x:0, y: 0, width: icW, height: icH))
            var txt1 = UILabel(frame: CGRect(x:0, y: icH, width: icW, height: txH))
            var txt2 = UILabel(frame: CGRect(x:0, y: icH, width: icW, height: txH))
            var txt3 = UILabel(frame: CGRect(x:0, y: icH, width: icW, height: txH))
            var txt4 = UILabel(frame: CGRect(x:0, y: icH, width: icW, height: txH))
            var txt5 = UILabel(frame: CGRect(x:0, y: icH, width: icW, height: txH))
            var txt6 = UILabel(frame: CGRect(x:0, y: icH, width: icW, height: txH))
            var txt7 = UILabel(frame: CGRect(x:0, y: icH, width: icW, height: txH))
            var txt8 = UILabel(frame: CGRect(x:0, y: icH, width: icW, height: txH))
            var btn1 = UIButton(frame: CGRect(x:icW*0, y: icY, width: icW, height: btnH))
            var btn2 = UIButton(frame: CGRect(x:icW*1, y: icY, width: icW, height: btnH))
            var btn3 = UIButton(frame: CGRect(x:icW*2, y: icY, width: icW, height: btnH))
            var btn4 = UIButton(frame: CGRect(x:icW*3, y: icY, width: icW, height: btnH))
            var btn5 = UIButton(frame: CGRect(x:icW*0, y: icY + btnH, width: icW, height: btnH))
            var btn6 = UIButton(frame: CGRect(x:icW*1, y: icY + btnH, width: icW, height: btnH))
            var btn7 = UIButton(frame: CGRect(x:icW*2, y: icY + btnH, width: icW, height: btnH))
            var btn8 = UIButton(frame: CGRect(x:icW*3, y: icY + btnH, width: icW, height: btnH))

            img1.image = UIImage(named: "entertainment")
            img2.image = UIImage(named: "grocery")
            img3.image = UIImage(named: "communication")
            img4.image = UIImage(named: "luxury")
            img5.image = UIImage(named: "gift")
            img6.image = UIImage(named: "health")
            img7.image = UIImage(named: "makeup")
            img8.image = UIImage(named: "luckyMoney")
            txt1.text = "entertainment"; txt1.textColor = UIColor.grayColor(); txt1.tag = 1
            txt2.text = "grocery";       txt2.textColor = UIColor.grayColor(); txt2.tag = 1
            txt3.text = "communication"; txt3.textColor = UIColor.grayColor(); txt3.tag = 1
            txt4.text = "luxury";        txt4.textColor = UIColor.grayColor(); txt4.tag = 1
            txt5.text = "gift";          txt5.textColor = UIColor.grayColor(); txt5.tag = 1
            txt6.text = "health";        txt6.textColor = UIColor.grayColor(); txt6.tag = 1
            txt7.text = "makeup";        txt7.textColor = UIColor.grayColor(); txt7.tag = 1
            txt8.text = "luckyMoney";    txt8.textColor = UIColor.grayColor(); txt8.tag = 1
            txt1.textAlignment = NSTextAlignment.Center; txt1.font = UIFont.systemFontOfSize(15)
            txt2.textAlignment = NSTextAlignment.Center; txt2.font = UIFont.systemFontOfSize(15)
            txt3.textAlignment = NSTextAlignment.Center; txt3.font = UIFont.systemFontOfSize(15)
            txt4.textAlignment = NSTextAlignment.Center; txt4.font = UIFont.systemFontOfSize(15)
            txt5.textAlignment = NSTextAlignment.Center; txt5.font = UIFont.systemFontOfSize(15)
            txt6.textAlignment = NSTextAlignment.Center; txt6.font = UIFont.systemFontOfSize(15)
            txt7.textAlignment = NSTextAlignment.Center; txt7.font = UIFont.systemFontOfSize(15)
            txt8.textAlignment = NSTextAlignment.Center; txt8.font = UIFont.systemFontOfSize(15)
           
            btnOK.backgroundColor  = UIColor.brownColor()
            btnOK.setTitle("Add", forState: UIControlState.Normal)
            btnOK.tag = 0
            btnOK.addTarget(self, action: "popupBtnTouch", forControlEvents: UIControlEvents.TouchUpInside)
            btn1.addTarget(self, action: "iconTouch:", forControlEvents: UIControlEvents.TouchUpInside)
            btn2.addTarget(self, action: "iconTouch:", forControlEvents: UIControlEvents.TouchUpInside)
            btn3.addTarget(self, action: "iconTouch:", forControlEvents: UIControlEvents.TouchUpInside)
            btn4.addTarget(self, action: "iconTouch:", forControlEvents: UIControlEvents.TouchUpInside)
            btn5.addTarget(self, action: "iconTouch:", forControlEvents: UIControlEvents.TouchUpInside)
            btn6.addTarget(self, action: "iconTouch:", forControlEvents: UIControlEvents.TouchUpInside)
            btn7.addTarget(self, action: "iconTouch:", forControlEvents: UIControlEvents.TouchUpInside)
            btn8.addTarget(self, action: "iconTouch:", forControlEvents: UIControlEvents.TouchUpInside)
            
            
            var textFiled = UITextField(frame: CGRect(x: 20, y: 300, width: 200, height: 30))
            textFiled.borderStyle = UITextBorderStyle.RoundedRect
            textFiled.tag = 2
            
            btn1.addSubview(img1); btn1.addSubview(txt1)
            btn2.addSubview(img2); btn2.addSubview(txt2)
            btn3.addSubview(img3); btn3.addSubview(txt3)
            btn4.addSubview(img4); btn4.addSubview(txt4)
            btn5.addSubview(img5); btn5.addSubview(txt5)
            btn6.addSubview(img6); btn6.addSubview(txt6)
            btn7.addSubview(img7); btn7.addSubview(txt7)
            btn8.addSubview(img8); btn8.addSubview(txt8)
            popupWin.addSubview(lab)
            popupWin.addSubview(title)
            popupWin.addSubview(tip1)
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
            self.superview?.superview!.addSubview(transpBG)
            self.superview?.superview!.addSubview(popupWin)//将弹窗添加到NewViewController
            self.superview?.userInteractionEnabled = false//大CollectionView不能用，但是Controller能用，所以弹窗是能用的

        }else{
            rightImg?.image = UIImage(named: "\(collectionViewDataSource[indexPath.row])")
            if (rightImg?.image == nil){
                rightImg?.image = UIImage(named: "blankCategory")
                rightText!.text = "\(collectionViewDataSource[indexPath.row])"
            }
            println("\(collectionViewDataSource[indexPath.row])")
            didSelectSection1 = false
            self.delegate?.didSelectSmallCell(indexPath: indexPath)
        }
    }
    
    func iconTouch(sender: UIButton){
        println("icon Touched.")
        println("\(popupWin.viewWithTag(2))")
        println("\(sender.viewWithTag(1))")
        var textField = popupWin.viewWithTag(2) as! UITextField
        var txtLabel = sender.viewWithTag(1) as! UILabel
        textField.text = txtLabel.text
    }
    
    func popupBtnTouch (){
        println("popup window Btn Touched.")
        var textField = popupWin.viewWithTag(2) as! UITextField
        var text = textField.text
        if (text == ""){
            println("no input")
        }else{
            //如果类别列表中没有选中项
            if !collectionViewDataSource.containsObject(text) {
                collectionViewDataSource.addObject(text)
                println("\(collectionViewDataSource)")
                collectionView!.reloadData()
            }
            //如果已经包含选中项，则什么都不做
        }
        popupWin.removeFromSuperview()
        transpBG.removeFromSuperview()
        self.superview?.userInteractionEnabled = true
    }
    
    //自定义代理 LongPressDelegate 方法实现
    func passSmallCellText(#smallCellText: String) {
        collectionViewDataSource.removeObject(smallCellText)
        println("\(collectionViewDataSource)")
        collectionView?.reloadData()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
