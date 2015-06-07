//
//  BIBillAnalysis.swift
//  moneyTracker
//
//  Created by User on 24/05/2015.
//  Copyright (c) 2015 User. All rights reserved.
//

import Foundation
import Foundation
class BIBillAnalysis: NSObject {
    // analyze Bill based on Income and Expense
    var usedCategories:[String] = []
    var expAmtByUsedCat:[Double] = []
    var incAmtByUsedCat:[Double] = []
    convenience init(year:Int,month:Int) {
        self.init()
        let catSQL:String = "SELECT Category FROM Expense WHERE YearOfExpense = \(year) AND MonthOfExpense = \(month)"
        let catsRepeat:[String] = BIQuery(UTF8StringQuery: catSQL).resultsOfQuery()
        for catR in catsRepeat {
            if !self.usedCategories.hasItem(catR, sameItem: catR) {
                self.usedCategories.append(catR)
            }
        }
        for catS in self.usedCategories {
            let expSQL:String = "SELECT SUM(Amounts) FROM Expense WHERE YearOfExpense = \(year) AND MonthOfExpense = \(month) AND Category = '\(catS)'"
            self.expAmtByUsedCat.append(BIQuery(UTF8StringQuery: expSQL).resultOfQuery() ?? 0.0)
        }
        for catS in self.usedCategories {
            let incSQL:String = "SELECT SUM(Amounts) FROM Income WHERE YearOfExpense = \(year) AND MonthOfExpense = \(month) AND Category = '\(catS)'"
            self.incAmtByUsedCat.append(BIQuery(UTF8StringQuery: incSQL).resultOfQuery() ?? 0.0)
        }
    }
    
    
    
    
    
    
    
    override init(){
        
        super.init()
    }
    deinit {
        println("BIBillAnalysis deinit")
    }
    
}