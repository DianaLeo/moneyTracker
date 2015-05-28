//
//  NewAmountCollectionViewCell.swift
//  moneyTracker
//
//  Created by User on 26/05/2015.
//  Copyright (c) 2015 User. All rights reserved.
//

import UIKit

class NewAmountCollectionViewCell: NewCollectionViewCell {
    
    var textField: UITextField?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 0.94, green: 0.93, blue: 0.93, alpha: 1)
        
        textField = UITextField(frame: CGRect(x: bgWidth - 200 - 20, y: 30, width: 200, height: 40))
        textField?.backgroundColor = UIColor.whiteColor()
        textField?.borderStyle = UITextBorderStyle.RoundedRect
        textField?.font = UIFont.systemFontOfSize(25)
        textField?.textAlignment = NSTextAlignment.Right
        textField?.placeholder = "Input amount"
        textField?.keyboardType = UIKeyboardType.NumberPad
        
        self.addSubview(textField!)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
