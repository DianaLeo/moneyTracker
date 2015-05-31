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
    var textLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.yellowColor()
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        imageView?.image = UIImage(named: "Billinfo---红包")
        imageView?.contentMode = UIViewContentMode.ScaleToFill
        textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        textLabel?.backgroundColor = UIColor.whiteColor()
        textLabel?.textAlignment = NSTextAlignment.Center
        //textLabel?.textColor = UIColor.lightGrayColor()
        self.addSubview(imageView!)
        self.addSubview(textLabel!)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
