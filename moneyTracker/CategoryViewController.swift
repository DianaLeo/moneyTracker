//
//  CategoryViewController.swift
//  moneyTracker
//
//  Created by User on 27/06/2015.
//  Copyright (c) 2015 User. All rights reserved.
//

import UIKit


protocol CategoryViewControllerDelegate: class {
    func categoryVCdidSelectBtnOK (#text: String)
}

class CategoryViewController: UIViewController {

    var popupWin = UIButton()
    var tip1 = UILabel()
    var tip2 = UILabel()
    var textFiled = UITextField()
    var imgs = [UIImageView](count: 12, repeatedValue: UIImageView())
    var txts = [UILabel](count: 12, repeatedValue: UILabel())
    var btns = [UIButton](count: 12, repeatedValue: UIButton())
    var naviBtnOK  = UIButton()
    var naviBtnCancel  = UIButton()
    weak var delegate: CategoryViewControllerDelegate?
    
    var _naviRatio      = 0.15 as CGFloat
    var _naviHeight     = CGFloat()
    
    // MARK: - VC funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //高度计算
        _naviHeight     = bgHeight * _naviRatio
        var icW = bgWidth*0.214  //icon 位置
        var icH = bgWidth*0.214
        var icY = _naviHeight + 150
        var txH = 40 as CGFloat
        var txY = icH - 10
        var btnW = bgWidth*0.23
        var btnH = txY + txH
        
        //背景 bg
        var bgImage = UIImageView(frame: CGRect(x: 0, y: 0, width: bgWidth, height: bgHeight))
        bgImage.image = UIImage(named: "background1")
        self.view.addSubview(bgImage)
        self.navigationItem.hidesBackButton = true

        tip1 = UILabel(frame: CGRect(x: 16, y: _naviHeight + 30, width: bgWidth - 32, height: 30))
        tip1.text = "Create your own:"
        tip1.textColor = UIColor(red: 0.82, green: 0.43, blue: 0.37, alpha: 1)
        tip1.font = UIFont.systemFontOfSize(20)
        
        textFiled = UITextField(frame: CGRect(x: 16, y: _naviHeight + 70, width: bgWidth - 32, height: 30))
        textFiled.borderStyle = UITextBorderStyle.RoundedRect
        
        tip2 = UILabel(frame: CGRect(x: 16, y: _naviHeight + 110, width: bgWidth - 32, height: 30))
        tip2.text = "Or Pick one from the following:"
        tip2.textColor = UIColor(red: 0.82, green: 0.43, blue: 0.37, alpha: 1)
        tip2.font = UIFont.systemFontOfSize(20)
        
        popupWin = UIButton(frame: CGRect(x: 0, y: _naviHeight, width: bgWidth, height: bgHeight - _naviHeight))
        popupWin.backgroundColor = UIColor(red: 0.94, green: 0.93, blue: 0.93, alpha: 1)
        popupWin.addTarget(self, action: "popupWinTouched", forControlEvents: UIControlEvents.TouchDown)
        
        self.view.addSubview(popupWin)
        self.view.addSubview(tip1)
        self.view.addSubview(tip2)
        
        for i in 0...11 {
            imgs[i] = UIImageView(frame: CGRect(x:0, y: 0, width: icW, height: icH))
            txts[i] = UILabel(frame: CGRect(x:0, y: txY, width: btnW, height: txH))
            txts[i].textColor = UIColor.darkGrayColor()
            txts[i].textAlignment = NSTextAlignment.Center
            txts[i].font = UIFont.systemFontOfSize(13)
            txts[i].numberOfLines = 0
            txts[i].tag = 1
            var row = floor(CGFloat(i)/CGFloat(4))
            btns[i] = UIButton(frame: CGRect(x:bgWidth*0.04 + CGFloat(i % 4)*btnW, y: icY + row*btnH, width: btnW, height: btnH))
            btns[i].addTarget(self, action: "iconTouch:", forControlEvents: UIControlEvents.TouchUpInside)
            btns[i].addSubview(imgs[i])
            btns[i].addSubview(txts[i])
            self.view.addSubview(btns[i])
        }
        
        imgs[0].image = UIImage(named: "entertainment")
        imgs[1].image = UIImage(named: "grocery")
        imgs[2].image = UIImage(named: "communication")
        imgs[3].image = UIImage(named: "luxury")
        imgs[4].image = UIImage(named: "gift")
        imgs[5].image = UIImage(named: "health")
        imgs[6].image = UIImage(named: "makeup")
        imgs[7].image = UIImage(named: "education")
        imgs[8].image = UIImage(named: "luckyMoney")
        imgs[9].image = UIImage(named: "fullTimeJob")
        imgs[10].image = UIImage(named: "partTimeJob")
        imgs[11].image = UIImage(named: "selling")
        txts[0].text = "Entertainment"
        txts[1].text = "Grocery"
        txts[2].text = "Communication"
        txts[3].text = "Luxury"
        txts[4].text = "Gift"
        txts[5].text = "Health"
        txts[6].text = "Makeup"
        txts[7].text = "Education"//添加到数据库
        txts[8].text = "LuckyMoney"
        txts[9].text = "FullTimeJob"//添加到数据库
        txts[10].text = "PartTimeJob"//添加到数据库
        txts[11].text = "Selling"//添加到数据库

        self.view.addSubview(textFiled)
    }
    
    override func viewWillAppear(animated: Bool) {
        (self.navigationController?.navigationBar.viewWithTag(1) as! UILabel).text = "Categories"
        
        naviBtnOK = UIButton(frame: CGRect(x: bgWidth - 70, y: bgHeight*0.015, width:55, height: 55))
        naviBtnOK.setBackgroundImage(UIImage(named: "save"), forState: UIControlState.Normal)
        naviBtnOK.addTarget(self, action: "naviBtnOKTouch", forControlEvents: UIControlEvents.TouchUpInside)
        
        naviBtnCancel = UIButton(frame: CGRect(x: 16, y: bgHeight*0.025, width: 40, height: 35))
        naviBtnCancel.setBackgroundImage(UIImage(named: "cancel"), forState: UIControlState.Normal)
        naviBtnCancel.addTarget(self, action: "naviBtnCancelTouch", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.navigationController?.navigationBar.addSubview(naviBtnOK)
        self.navigationController?.navigationBar.addSubview(naviBtnCancel)
    }
    
    
    // MARK: - 小弹窗内部功能
    func iconTouch(sender: UIButton){
        var txtLabel = sender.viewWithTag(1) as! UILabel
        textFiled.text = txtLabel.text
        textFiled.endEditing(true)
    }
    
    func naviBtnOKTouch (){
        naviBtnOK.removeFromSuperview()
        naviBtnCancel.removeFromSuperview()
        
        var text = textFiled.text
        if (text == ""){
            println("no input")
        }else{
            self.delegate?.categoryVCdidSelectBtnOK(text: text)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func naviBtnCancelTouch(){
        naviBtnOK.removeFromSuperview()
        naviBtnCancel.removeFromSuperview()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func popupWinTouched(){
        textFiled.endEditing(true)
    }

    // MARK: - others
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
