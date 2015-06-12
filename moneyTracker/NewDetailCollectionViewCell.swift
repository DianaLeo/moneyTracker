//
//  NewDetailCollectionViewCell.swift
//  moneyTracker
//
//  Created by User on 26/05/2015.
//  Copyright (c) 2015 User. All rights reserved.
//

import UIKit
import CoreGraphics

class NewDetailCollectionViewCell: NewCollectionViewCell {

    var textView: UITextView?
    var rightLabel: UILabel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var cellHeight = bgWidth*0.71
        textView = UITextView(frame: CGRect(x: 20, y: 60, width: bgWidth-40, height: cellHeight - 80))
        textView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        textView?.font = UIFont.systemFontOfSize(20)
        textView?.hidden = true
        leftTextLabel?.text = "Detail"
        rightLabel = UILabel(frame: CGRect(x: bgWidth - 170 - 50, y: 30, width: 170, height: 40))
        rightLabel?.textAlignment = NSTextAlignment.Right
        rightLabel?.textColor = UIColor(red: 0.53, green: 0.53, blue: 0.53, alpha: 1)
        rightLabel?.font = UIFont.italicSystemFontOfSize(25)
        
        self.addSubview(textView!)
        self.addSubview(rightLabel!)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
