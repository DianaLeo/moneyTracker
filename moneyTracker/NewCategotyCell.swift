//
//  NewCategotyCollectionCell.swift
//  moneyTracker
//
//  Created by User on 26/05/2015.
//  Copyright (c) 2015 User. All rights reserved.
//

import UIKit

protocol LongPressDelegate {
    func passSmallCellText (#smallCellText: String)
}


class NewCategotyCell: UICollectionViewCell,UIAlertViewDelegate {
    
    var img: UIImageView?
    var label: UILabel?
    var longPressGestureRecognizer: UILongPressGestureRecognizer?
    var delegate: LongPressDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        img = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.width))
        img?.image = UIImage(named: "clothing")

        label = UILabel(frame: CGRect(x: 0, y: frame.width*0.9, width: frame.width, height: 20))
        label?.text = "clothing"
        label?.textAlignment = NSTextAlignment.Center
        label?.textColor = UIColor(red: 0.53, green: 0.53, blue: 0.53, alpha: 1)
        label?.font = UIFont.systemFontOfSize(15)
        
        longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "handleLongPressGesture:")
        longPressGestureRecognizer!.numberOfTouchesRequired = 1
        longPressGestureRecognizer!.allowableMovement = 50
        longPressGestureRecognizer!.minimumPressDuration = 1
        
        self.addSubview(img!)
        self.addSubview(label!)
        self.addGestureRecognizer(longPressGestureRecognizer!)
    }

    //长按手势识别
    func handleLongPressGesture(recognizer:UILongPressGestureRecognizer){
        if ((recognizer.state == UIGestureRecognizerState.Began)&&(label?.text != "New")&&(label?.text != "Clothing")&&(label?.text != "Food")&&(label?.text != "Accommodation")&&(label?.text != "Transport")){
            var alert:UIAlertView? = UIAlertView(title: "Delete", message: "Are you sure you want to delete \((label?.text)!) category?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Yes")
            alert!.show()
            println("longPress")
        }
    }
    //alertview点击确认
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if (buttonIndex == 1){
            self.delegate?.passSmallCellText(smallCellText: (label?.text)!)
            println("alertview btnOK clicked")
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
