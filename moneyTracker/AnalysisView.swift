//
//  AnalysisView.swift
//  moneyTracker
//
//  Created by User on 9/06/2015.
//  Copyright (c) 2015 User. All rights reserved.
//

import UIKit

class AnalysisView: UIView {

    //颜色
    var edgeColor   = UIColor(red: 0.58, green: 0.30, blue: 0.41, alpha: 1)
    var redColor    = UIColor(red: 0.82, green: 0.43, blue: 0.37, alpha: 1)
    var yellowColor = UIColor(red: 0.96, green: 0.90, blue: 0.72, alpha: 1)
    var purpleColor = UIColor(red: 0.54, green: 0.39, blue: 0.58, alpha: 1)
    var pinkColor   = UIColor(red: 0.94, green: 0.78, blue: 0.71, alpha: 1)
    var blueColor   = UIColor(red: 0.53, green: 0.75, blue: 0.71, alpha: 1)
    var whiteColor  = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1)
    var colors      = [UIColor](count: 6, repeatedValue: UIColor.lightGrayColor())
    
    //数据
    var categories  = [String](count: 6, repeatedValue: "")
    var ratios      = [Double](count: 6, repeatedValue: 0.0)
    
    //属性
    var title       = UILabel()
    var legends     = [UILabel](count: 6, repeatedValue: UILabel())
    var textLabels  = [UILabel](count: 6, repeatedValue: UILabel())

    override init(frame: CGRect) {
        super.init(frame: frame)
        colors = [yellowColor,redColor,blueColor,pinkColor,purpleColor,whiteColor]
        var l1Y = Int(bgWidth - 35)//20
        title = UILabel(frame: CGRect(x: 25, y: 10, width: 150, height: 30))
        //title.textColor = UIColor.whiteColor()
        title.font = UIFont.systemFontOfSize(22)
        self.addSubview(title)
        for i in 0...5{
            legends[i] = UILabel(frame: CGRect(x: 70, y: l1Y + 42*i, width: 80, height: 30))
            legends[i].backgroundColor = colors[i]
            legends[i].textAlignment = NSTextAlignment.Center
            legends[i].textColor = UIColor.blackColor()
            legends[i].font = UIFont.systemFontOfSize(18)
            textLabels[i] = UILabel(frame: CGRect(x: 170, y: l1Y + 42*i, width: Int(bgWidth - 120), height: 30))
            textLabels[i].textColor = UIColor.blackColor()
            textLabels[i].font = UIFont.systemFontOfSize(18)
            self.addSubview(legends[i])
            self.addSubview(textLabels[i])
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        println("draw a fan figure.")
        var endAngle = 0 as Double
        var startAngle = 0 as Double
        var context: CGContextRef = UIGraphicsGetCurrentContext()

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
            drawFanForRange(color: colors[i], start: startAngle, end: endAngle, context: context)
        }
    }
    
    func passValue(#passedCategories: [String], passedRatios: [Double]){
        categories = passedCategories
        ratios = passedRatios
    }
    
    func drawFanForRange(#color: UIColor, start: Double, end: Double, context: CGContextRef){
        //var context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextMoveToPoint(context, bgWidth/2, bgWidth/2 - 10)
        CGContextAddArc(context, bgWidth/2, bgWidth/2 - 10, bgWidth/2 - 50, CGFloat((start - 0.25)*2*M_PI), CGFloat((end - 0.25)*2*M_PI), 0)
        CGContextClosePath(context)
        CGContextFillPath(context)
    }
    
    func drawLegends(){
        for i in 0...5{
            if (ratios[i] != 0){
                legends[i].text = "\(Float(Int(ratios[i]*1000+0.5))/10)%"
                textLabels[i].text = categories[i]
                legends[i].hidden = false
                textLabels[i].hidden = false
            }else{
                legends[i].hidden = true
                textLabels[i].hidden = true
            }
        }
    }

}
