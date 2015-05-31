//
//  TestViewController.swift
//  moneyTracker
//
//  Created by User on 24/05/2015.
//  Copyright (c) 2015 User. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    let aIncome = BIIncome()
    let aExpense = BIExpense()
    var name: NSString?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.grayColor()
        BIExpense(year: 2015, month: 5, day: 29, category: "L", categoryDetail: nil, amounts: 90.9, expenseDetail: nil, receiptImage: nil)
        //createDatabaseOnceIfNotExists()
        //InitBIDataSetDatabase.writeDataOnce()
//        var query = BIQuery(UTF8StringQuery: "SELECT SUM(Amounts) FROM Income WHERE Month = 5 AND Year = 2015")
//        query.resultOfQuery()
        //let str = NSDateFormatter.localizedStringFromDate(date, dateStyle: NSDateFormatterStyle.FullStyle, timeStyle: NSDateFormatterStyle.FullStyle)
        //println(str)
        //var mC = BIMonthCalender(dateForMonthCalender: date)
        //mC.monthCalender()
        //var dataSet = BIDataSet.sharedInstance()
//        dispatch_async(dispatch_get_main_queue(), { () in
//            self.name = "TestVC"
//            println("set name in other thread")
//            var dataSet1 = BIDataSet.sharedInstance()
//            })
        }
        // Do any additional setup after loading the view.

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        println("Test VC Deinit")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
