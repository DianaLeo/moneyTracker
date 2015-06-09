//
//  AnalysisView.swift
//  moneyTracker
//
//  Created by User on 9/06/2015.
//  Copyright (c) 2015 User. All rights reserved.
//

import UIKit

class AnalysisView: UIView {

    var color = UIColor.redColor()
    var edgeColor   = UIColor(red: 0.58, green: 0.30, blue: 0.41, alpha: 1)
    var redColor    = UIColor(red: 0.82, green: 0.43, blue: 0.37, alpha: 1)
    var yellowColor = UIColor(red: 0.96, green: 0.90, blue: 0.72, alpha: 1)
    var purpleColor = UIColor(red: 0.54, green: 0.39, blue: 0.58, alpha: 1)
    var pinkColor   = UIColor(red: 0.94, green: 0.78, blue: 0.71, alpha: 1)
    var blueColor   = UIColor(red: 0.53, green: 0.75, blue: 0.71, alpha: 1)
    var whiteColor  = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1)
    var colors = [redColor,yellowColor,purpleColor,pinkColor,blueColor,whiteColor]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        var context = UIGraphicsGetCurrentContext()
        CGContextSetAllowsAntialiasing(context, true)
        CGContextSetStrokeColorWithColor(context, color.CGColor)
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextAddEllipseInRect(context, CGRect(x: 50, y: 50, width: 100, height: 100))
        CGContextFillPath(context)
        CGContextStrokePath(context)
    }
    
    func passValue(color passedColor: UIColor){
        color = passedColor
    }

}
