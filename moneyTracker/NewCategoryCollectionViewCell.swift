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

class NewCategoryCollectionViewCell: NewCollectionViewCell,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate {
    
    var collectionViewDataSource = ["clothing","food","accomontation","transport","entertainment","grocery","luxury"]
    
    var rightImg: UIImageView?
    var flowLayOut = UICollectionViewFlowLayout()
    var collectionView: UICollectionView?
    var delegate: SmallCategoryCellDelegate?
    var popupWin = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        var defaultCellHeight = 100 as CGFloat
        var cellHeight = bgHeight * (1 - 0.15) - defaultCellHeight * 3
        var smallCellW = 80 as CGFloat
        var smallCellH = 100 as CGFloat
        rightImg = UIImageView(frame: CGRect(x: bgWidth - 80 - 45, y: 10, width: smallCellW, height: smallCellW))
        
        flowLayOut.itemSize = CGSize(width: smallCellW, height: smallCellH)
        flowLayOut.minimumInteritemSpacing = 0
        flowLayOut.minimumLineSpacing = 0
        flowLayOut.scrollDirection = UICollectionViewScrollDirection.Vertical
        //高度根据Category个数改变，每四个加一行，即100，初始值为两行8个图标
        collectionView = UICollectionView(frame: CGRect(x: 20, y: 60, width: bgWidth - 40, height: 200), collectionViewLayout: flowLayOut)
        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.dataSource = self
        collectionView?.delegate   = self
        
        self.addSubview(rightImg!)
        self.addSubview(collectionView!)

    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewDataSource.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        collectionView.registerClass(NewCategotyCell.self, forCellWithReuseIdentifier: "newDateCell")
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("newDateCell", forIndexPath: indexPath) as! NewCategotyCell
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
        if (indexPath.row == collectionViewDataSource.count){
            popupWin = UIView(frame: CGRect(x: 15, y: 120, width: bgWidth - 30, height: 300))
            var Bg = UIImageView(frame: CGRect(x: 0, y: 0, width: bgWidth - 30, height: 300))
            Bg.image = UIImage(named: "popupWin")
            var Btn1 = UIButton(frame: CGRect(x: 10, y: 10, width: 45, height: 45))
            Btn1.backgroundColor = UIColor.magentaColor()
            Btn1.tag = 0
            Btn1.addTarget(self, action: "popupBtnTouch", forControlEvents: UIControlEvents.TouchUpInside)
            var textFiled = UITextField(frame: CGRect(x: 20, y: 250, width: 100, height: 30))
            textFiled.borderStyle = UITextBorderStyle.RoundedRect
            textFiled.tag = 1
            popupWin.addSubview(Bg)
            popupWin.addSubview(Btn1)
            popupWin.addSubview(textFiled)
            self.superview?.addSubview(popupWin)
            //self.superview?.userInteractionEnabled = false
//            var alert = UIAlertView(title: "original title", message: "original message", delegate: self, cancelButtonTitle: "cancel", otherButtonTitles: "btn1","btn2","btn3")
//            alert.title = "New Category"
//            alert.message = "Pick one from the existing list:"
//            alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
//            alert.show()
        }else{
            rightImg?.image = UIImage(named: "\(collectionViewDataSource[indexPath.row])")
            didSelectSection1 = false
            self.delegate?.didSelectSmallCell(indexPath: indexPath)
        }
    }
    
    func popupBtnTouch (){
        println("popup window Btn1 Touched.")
        var textField = popupWin.viewWithTag(1) as! UITextField
        var text = textField.text
        if (text == ""){
            println("no input")
        }else{
            collectionViewDataSource.append(text)
            println("\(collectionViewDataSource)")
            collectionView!.reloadData()
        }
        popupWin.removeFromSuperview()
    }
    
    

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
