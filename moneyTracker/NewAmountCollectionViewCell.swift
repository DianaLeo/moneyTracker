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
        var textFieldWidth = bgWidth*0.5
        self.backgroundColor = UIColor(red: 0.94, green: 0.93, blue: 0.93, alpha: 1)
        leftTextLabel?.text = "Amount"
        textField = UITextField(frame: CGRect(x: bgWidth - textFieldWidth - 20, y: 30, width: textFieldWidth, height: 40))
        textField?.backgroundColor = UIColor.whiteColor()
        textField?.borderStyle = UITextBorderStyle.RoundedRect
        textField?.font = UIFont.systemFontOfSize(25)
        textField?.textAlignment = NSTextAlignment.Right
        textField?.placeholder = "Input amount"
        textField?.keyboardType = UIKeyboardType.NumbersAndPunctuation
        
        self.addSubview(textField!)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
