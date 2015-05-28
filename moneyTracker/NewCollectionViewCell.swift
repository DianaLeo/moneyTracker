//
//  NewCollectionViewCell.swift
//  moneyTracker
//
//  Created by User on 25/05/2015.
//  Copyright (c) 2015 User. All rights reserved.
//

import UIKit

class NewCollectionViewCell: UICollectionViewCell {
    
    var bgWidth  = UIScreen.mainScreen().bounds.width
    var bgHeight = UIScreen.mainScreen().bounds.height
    
    var leftTextLabel: UILabel?
    var bottomEdge: UILabel?
    var accImg: UIImageView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        leftTextLabel = UILabel(frame: CGRect(x: 30, y: 20, width: 150, height: 40))
        leftTextLabel?.textColor = UIColor(red: 0.82, green: 0.47, blue: 0.43, alpha: 1)
        leftTextLabel?.font      = UIFont.boldSystemFontOfSize(22)
        
        bottomEdge = UILabel(frame: CGRect(x: 0, y: 0, width: bgWidth, height: 1))
        bottomEdge?.backgroundColor = UIColor(red: 0.51, green: 0.48, blue: 0.46, alpha: 0.5)
        
        var accBtnRect = CGRect(x: bgWidth - 45, y: 30, width: 30, height: 30)
        accImg = UIImageView(frame: accBtnRect)
        accImg?.image = UIImage(named: "dragdown")
        
        self.addSubview(leftTextLabel!)
        self.addSubview(bottomEdge!)
        self.addSubview(accImg!)

    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
