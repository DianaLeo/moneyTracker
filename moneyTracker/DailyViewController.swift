//
//  DailyTableViewController.swift
//  moneyTracker
//
//  Created by User on 24/05/2015.
//  Copyright (c) 2015 User. All rights reserved.
//

import UIKit

class DailyViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var flagExpense = 1
    var listTable = UITableView()
    
    var bgWidth  = UIScreen.mainScreen().bounds.size.width
    var bgHeight = UIScreen.mainScreen().bounds.size.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //高度计算
        var naviHeight      = self.navigationController?.navigationBar.frame.height
        var naviY           = self.navigationController?.navigationBar.frame.origin.y
        var _naviRatio      = 0.15 as CGFloat
        var _naviHeight     = bgHeight * _naviRatio
        var naviImageHeight = _naviHeight - naviY! - naviHeight!
        var tabHeight       = 50.0 as CGFloat

        //背景
        var bgImage = UIImageView(frame: CGRect(x: 0, y: 0, width: bgWidth, height: bgHeight))
        bgImage.image = UIImage(named: "background1")
        self.view.addSubview(bgImage)
        
        
        //上标签（收支）tab
        var tabBtnEx = UIButton(frame: CGRect(x: 0, y: _naviHeight, width: bgWidth/2, height: tabHeight))
        var tabBtnIn = UIButton(frame: CGRect(x: bgWidth/2, y: _naviHeight, width: bgWidth/2, height: tabHeight))
        tabBtnEx.backgroundColor = UIColor(patternImage: UIImage(named: "expense")!)
        tabBtnIn.backgroundColor = UIColor(patternImage: UIImage(named: "income")!)
        tabBtnEx.setTitle("Expense", forState: UIControlState.Normal)
        tabBtnIn.setTitle("Income", forState: UIControlState.Normal)
        tabBtnEx.addTarget(self, action: "tabBtnExTouch", forControlEvents: UIControlEvents.TouchUpInside)
        tabBtnIn.addTarget(self, action: "tabBtnInTouch", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(tabBtnEx)
        self.view.addSubview(tabBtnIn)
        
        
        //详细列表 list
        listTable = UITableView(frame: CGRect(x: 0, y: _naviHeight + tabHeight, width: bgWidth, height: bgHeight - _naviHeight - tabHeight), style: UITableViewStyle.Plain)
        listTable.dataSource = self
        listTable.delegate   = self
        listTable.separatorStyle = UITableViewCellSeparatorStyle.None
        self.view.addSubview(listTable)
        
    }
    
    
    //详细列表 tableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.registerClass(DailyTableViewCell.self, forCellReuseIdentifier: "DailyListCell")
        var cell = tableView.dequeueReusableCellWithIdentifier("DailyListCell", forIndexPath: indexPath) as? DailyTableViewCell
        if (indexPath.row%2 == 0) {
            cell?.backgroundColor = UIColor.whiteColor()
        }else{
            cell?.backgroundColor = UIColor(red: 0.94, green: 0.93, blue: 0.93, alpha: 1)
        }
        var image    = cell?.leftImageView
        var leftText = cell?.leftTextLabel
        var detail   = cell?.detailLabel
        var righText = cell?.rightTextLabel
        
        if (flagExpense == 1){
            image?.image = UIImage(named: "clothing")
            leftText?.text = "Category"
            detail?.text = "Location"
            righText?.text = "-75"
        }else{
            image?.image = UIImage(named: "food")
            leftText?.text = "Cate2"
            leftText?.textColor = UIColor(red: 0.82, green: 0.47, blue: 0.43, alpha: 1)
            leftText?.font = UIFont.boldSystemFontOfSize(22)
            detail?.text = "Something"
            detail?.textColor = UIColor(red: 0.53, green: 0.53, blue: 0.53, alpha: 1)
            detail?.font = UIFont.italicSystemFontOfSize(15)
            righText?.text = "+100"
            righText?.textColor = UIColor(red: 0.82, green: 0.47, blue: 0.43, alpha: 1)
            righText?.textAlignment = NSTextAlignment.Right
            righText?.font = UIFont.boldSystemFontOfSize(33)
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    //导航栏按钮点击事件 - 不管点哪个都要移除右边的按钮，而左边的按钮自动移除
    func naviBtnNewTouch () {
        var naviBtnNew = self.navigationController?.navigationBar.viewWithTag(2) as! UIButton
        var naviBtnNewImg = self.navigationController?.navigationBar.viewWithTag(3) as! UIImageView
        naviBtnNew.removeFromSuperview()
        naviBtnNewImg.removeFromSuperview()
        self.navigationController?.pushViewController(NewViewController(), animated: true)
    }
    
    func naviBtnBackTouch () {
        var naviBtnNew = self.navigationController?.navigationBar.viewWithTag(2) as! UIButton
        var naviBtnNewImg = self.navigationController?.navigationBar.viewWithTag(3) as! UIImageView
        naviBtnNew.removeFromSuperview()
        naviBtnNewImg.removeFromSuperview()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func tabBtnExTouch () {
        flagExpense = 1
        listTable.reloadData()
    }
    
    func tabBtnInTouch () {
        flagExpense = 0
        listTable.reloadData()
    }
    
    //导航－页面即将显示
    override func viewWillAppear(animated: Bool) {
        var naviLabel = self.navigationController?.navigationBar.viewWithTag(1) as! UILabel
        naviLabel.text = "25/05/2015"
        
        var naviBtnNewRect = CGRect(x: bgWidth - 70, y: 10, width: 55, height: 55)
        var naviBtnNew     = UIButton(frame: naviBtnNewRect)
        var naviBtnNewImg  = UIImageView(frame: naviBtnNewRect)
        naviBtnNewImg.image = UIImage(named: "new")
        naviBtnNew.addSubview(naviBtnNewImg)
        naviBtnNew.addTarget(self, action: "naviBtnNewTouch", forControlEvents: UIControlEvents.TouchUpInside)
        naviBtnNew.tag    = 2
        naviBtnNewImg.tag = 3
        self.navigationController?.navigationBar.addSubview(naviBtnNew)
        self.navigationController?.navigationBar.addSubview(naviBtnNewImg)
        
        var naviBtnBackRect  = CGRect(x: 0, y: 10, width: 40, height: 35)
        var naviBtnBack      = UIButton(frame: naviBtnBackRect)
        var naviBtnBackImg   = UIImageView(frame: naviBtnBackRect)
        naviBtnBackImg.image = UIImage(named: "back")
        naviBtnBack.addSubview(naviBtnBackImg)
        naviBtnBack.addTarget(self, action: "naviBtnBackTouch", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: naviBtnBack)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
