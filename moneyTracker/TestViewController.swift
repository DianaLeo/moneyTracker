//
//  TestViewController.swift
//  moneyTracker
//
//  Created by User on 24/05/2015.
//  Copyright (c) 2015 User. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.grayColor()
        deleteDatabase()
        BIIncome.deleteTableInDatabase()
        BIExpense.deleteTableInDatabase()
        createDatabaseOnceIfNotExists()
//        BIExpense(year: 2015, month: 5, day: 29, category: "L", categoryDetail: nil, amounts: 90.9, expenseDetail: nil, receiptImage: nil)
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
