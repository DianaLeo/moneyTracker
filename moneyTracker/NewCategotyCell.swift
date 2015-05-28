//
//  NewCategotyCollectionCell.swift
//  moneyTracker
//
//  Created by User on 26/05/2015.
//  Copyright (c) 2015 User. All rights reserved.
//

import UIKit



class NewCategotyCell: UICollectionViewCell {
    
    var img: UIImageView?
    var label: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        img = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.width))
        img?.image = UIImage(named: "clothing")

        label = UILabel(frame: CGRect(x: 0, y: frame.width, width: frame.width, height: 20))
        label?.text = "clothing"
        label?.textAlignment = NSTextAlignment.Center
        label?.textColor = UIColor(red: 0.53, green: 0.53, blue: 0.53, alpha: 1)
        label?.font = UIFont.systemFontOfSize(15)
        
        self.addSubview(img!)
        self.addSubview(label!)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
