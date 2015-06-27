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
    func didSelectLastCell (#indexPath: NSIndexPath)
}

class NewCategoryCollectionViewCell: NewCollectionViewCell,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,LongPressDelegate {
    
    var collectionViewDataSource = NSMutableArray()
    var userCategoryDS = BICategory.sharedInstance()
    
    var rightImg: UIImageView?
    var rightText: UILabel?
    var flowLayOut = UICollectionViewFlowLayout()
    var collectionView: UICollectionView?
    weak var delegate: SmallCategoryCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // category
        self.collectionViewDataSource = NSMutableArray(array: userCategoryDS.expenseCategories)
        
        var cellHeight = bgWidth*0.71
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
        collectionView = UICollectionView(frame: CGRect(x: 20, y: 60, width: bgWidth - 40, height: cellHeight - 60), collectionViewLayout: flowLayOut)
        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.dataSource = self
        collectionView?.delegate   = self
        
        self.addSubview(rightImg!)
        self.addSubview(rightText!)
        self.addSubview(collectionView!)
    }
    
    
    //MARK: - collectionView
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
        
        if (indexPath.row == collectionViewDataSource.count){
            self.delegate?.didSelectLastCell(indexPath: indexPath)

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

    
    //MARK: - 自定义代理LongPressDelegate方法实现
    func passSmallCellText(#smallCellText: String) {
        collectionViewDataSource.indexOfObject(smallCellText)
        userCategoryDS.expenseCategories.removeAtIndex(collectionViewDataSource.indexOfObject(smallCellText))
        collectionViewDataSource = NSMutableArray(array: userCategoryDS.expenseCategories)
        collectionView?.reloadData()
    }
    
    //MARK: - others
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        println("new category collection view cell deinit")
    }
}
