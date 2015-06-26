//
//  calndrCollectionViewCell.swift
//  moneyTracker
//
//  Created by User on 23/05/2015.
//  Copyright (c) 2015 User. All rights reserved.
//

import UIKit

class calndrCollectionViewCell: UICollectionViewCell {
    
    var imageView: UIImageView?
    var textBtn: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        var selectedBGview = UIView(frame: frame)
        selectedBGview.backgroundColor = UIColor(white: 0.9, alpha: 1)
        self.selectedBackgroundView = selectedBGview
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        imageView?.image = UIImage(named: "calndrCellLuckyMoney")
        imageView?.contentMode = UIViewContentMode.ScaleToFill
        imageView?.hidden = true

        textBtn = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        textBtn?.backgroundColor = UIColor.clearColor()
        textBtn?.textAlignment = NSTextAlignment.Center
        
        self.addSubview(imageView!)
        self.addSubview(textBtn!)
    }

    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
