//
//  AnalysisView.swift
//  moneyTracker
//
//  Created by User on 9/06/2015.
//  Copyright (c) 2015 User. All rights reserved.
//

import UIKit

class AnalysisView: UIView {

    //高度计算
    var bgWidth  = UIScreen.mainScreen().bounds.size.width
    var bgHeight = UIScreen.mainScreen().bounds.size.height

    //颜色
    var edgeColor   = UIColor(red: 0.58, green: 0.30, blue: 0.41, alpha: 1)
    var redColor    = UIColor(red: 0.82, green: 0.43, blue: 0.37, alpha: 1)
    var yellowColor = UIColor(red: 0.96, green: 0.90, blue: 0.72, alpha: 1)
    var purpleColor = UIColor(red: 0.54, green: 0.39, blue: 0.58, alpha: 1)
    var pinkColor   = UIColor(red: 0.94, green: 0.78, blue: 0.71, alpha: 1)
    var blueColor   = UIColor(red: 0.53, green: 0.75, blue: 0.71, alpha: 1)
    var whiteColor  = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1)
    var colors = [UIColor]()
    
    //数据
    var categories = ["1","2","3","4","5","6"]
    var ratios = [0.1,0.1,0.1,0.1,0.1,0.1]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        colors = [redColor,yellowColor,purpleColor,pinkColor,blueColor,whiteColor]
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        var endAngle = 0 as Double
        var startAngle = 0 as Double
        var context = UIGraphicsGetCurrentContext()

        CGContextSetAllowsAntialiasing(context, true)
        CGContextSetLineWidth(context, 5)
        CGContextSetStrokeColorWithColor(context, edgeColor.CGColor)
        CGContextSetFillColorWithColor(context, whiteColor.CGColor)
        CGContextAddEllipseInRect(context, CGRect(x: 45, y: 35, width: bgWidth - 90, height: bgWidth - 90))
        CGContextStrokePath(context)
        CGContextFillEllipseInRect(context, CGRect(x: 50, y: 40, width: bgWidth - 100, height: bgWidth - 100))

        for i in 0...5{
            endAngle = endAngle + ratios[i]
            startAngle = endAngle - ratios[i]
            drawFanForRange(color: colors[i], start: startAngle, end: endAngle)
        }
    }
    
    func passValue(#passedCategories: [String], passedRatios: [Double]){
        categories = passedCategories
        ratios = passedRatios
    }
    
    func drawFanForRange(#color: UIColor, start: Double, end: Double){
        var context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextMoveToPoint(context, bgWidth/2, bgWidth/2 - 10)
        CGContextAddArc(context, bgWidth/2, bgWidth/2 - 10, bgWidth/2 - 50, CGFloat((start - 0.25)*2*M_PI), CGFloat((end - 0.25)*2*M_PI), 0)
        CGContextClosePath(context)
        CGContextFillPath(context)
    }

}