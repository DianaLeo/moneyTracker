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
    var expCatSix:[String] = []
    var incCatSix:[String] = []
    var expSix:[Double] = []
    var incSix:[Double] = []
    
    //internal variables
    private var sortOrder:Array<Bool> = []
    private var incSortOrder:Array<Bool> = []
    
    private var expUsedCategories:[String] = []
    private var incUsedCategories:[String] = []
    
    private var expAmtByUsedCat:[Double] = []
    private var incAmtByUsedCat:[Double] = []
    
    private var expAmtPercentage:[Double] = []
    private var incAmtPercentage:[Double] = []
    
    convenience init(year:Int,month:Int) {
        self.init()
        let catSQL:String = "SELECT Category FROM Expense WHERE YearOfExpense = \(year) AND MonthOfExpense = \(month)"
        let catsRepeat:[String] = BIQuery(UTF8StringQuery: catSQL).resultsOfQuery()
        for catR in catsRepeat {
            if !self.expUsedCategories.hasItem(catR, sameItem: catR) {
                self.expUsedCategories.append(catR)
            }
        }
        let incCatSQL:String = "SELECT Category FROM Income WHERE YearOfIncome = \(year) AND MonthOfIncome = \(month)"
        let incCatsRepeat:[String] = BIQuery(UTF8StringQuery: incCatSQL).resultsOfQuery()
        for incCatR in incCatsRepeat {
            if !self.incUsedCategories.hasItem(incCatR, sameItem: incCatR) {
                self.incUsedCategories.append(incCatR)
            }
        }
        println(self.incUsedCategories)
        for catS in self.expUsedCategories {
            let expSQL:String = "SELECT SUM(Amounts) FROM Expense WHERE YearOfExpense = \(year) AND MonthOfExpense = \(month) AND Category = '\(catS)'"
            self.expAmtByUsedCat.append(BIQuery(UTF8StringQuery: expSQL).resultOfQuery() ?? 0.0)
        }
        for catS in self.incUsedCategories {
            let incSQL:String = "SELECT SUM(Amounts) FROM Income WHERE YearOfIncome = \(year) AND MonthOfIncome = \(month) AND Category = '\(catS)'"
            self.incAmtByUsedCat.append(BIQuery(UTF8StringQuery: incSQL).resultOfQuery() ?? 0.0)
        }
        if self.expUsedCategories.count > 0 {
            sortCatsAndAmt()
            self.expAmtPercentage = amtToPercentage(self.expAmtByUsedCat)
            //self.incAmtPercentage = amtToPercentage(self.incAmtByUsedCat)
            makeExpSix()
            //makeIncSix()
        }else{
            self.expCatSix = ["EmptyCategory","","","","",""]
            self.expSix = [0,0,0,0,0,0]
        }
        if self.incUsedCategories.count > 0 {
            incSortCatsAndAmt()
            //self.expAmtPercentage = amtToPercentage(self.expAmtByUsedCat)
            self.incAmtPercentage = amtToPercentage(self.incAmtByUsedCat)
            //makeExpSix()
            makeIncSix()
        }else{
            self.incCatSix = ["EmptyCategory","","","","",""]
            self.incSix = [0,0,0,0,0,0]
        }
    }
    private func amtToPercentage(amtAry:[Double]) -> [Double]{
        var sum:Double = 0
        var perAry:[Double] = []
        for amt in amtAry {
            sum += amt
        }
        for i in 1...amtAry.count{
            let per = amtAry[i-1]/sum
            perAry.append(per)
        }
        return perAry
    }
    private func sortCatsAndAmt(){
        sort(&self.expAmtByUsedCat, { [unowned self](a,b) in
            let bool:Bool = a > b
            self.sortOrder.append(bool)
            return bool
            })
        var i = 0
        sort(&self.expUsedCategories, { [unowned self] (_,_) in
            i++
            return self.sortOrder[i-1]
            })
        //        println(self.usedCategories)
        //        println(self.expAmtByUsedCat)
    }
    private func incSortCatsAndAmt(){
        sort(&self.incAmtByUsedCat, { [unowned self](a,b) in
            let bool:Bool = a > b
            self.incSortOrder.append(bool)
            return bool
            })
        var i = 0
        sort(&self.incUsedCategories, { [unowned self] (_,_) in
            i++
            return self.incSortOrder[i-1]
            })
        //        println(self.usedCategories)
        //        println(self.expAmtByUsedCat)
    }
    private func makeExpSix(){
        if self.expUsedCategories.count == 6{
            for i in 0...5{
                self.expSix.append(self.expAmtPercentage[i])
                self.expCatSix.append(self.expUsedCategories[i])
            }
        }else if self.expUsedCategories.count > 6 {
            for i in 0...4{
                self.expSix.append(self.expAmtPercentage[i])
                self.expCatSix.append(self.expUsedCategories[i])
            }
            var sumAfterSix:Double = 0
            for i in 5...self.expUsedCategories.count-1 {
                sumAfterSix += self.expAmtPercentage[i]
            }
            self.expSix.append(sumAfterSix)
            self.expCatSix.append("Others")
        }else{
            for i in 0...self.expUsedCategories.count-1 {
                self.expSix.append(self.expAmtPercentage[i])
                self.expCatSix.append(self.expUsedCategories[i])
            }
            for i in (self.expUsedCategories.count)...5{
                self.expSix.append(0)
                self.expCatSix.append("Others")
            }
        }
    }
    //Category Error: Need to update to IncCategory
    private func makeIncSix(){
        if self.incUsedCategories.count == 6{
            for i in 0...5{
                self.incSix.append(self.incAmtPercentage[i])
                self.incCatSix.append(self.incUsedCategories[i])
            }
        }else if self.incUsedCategories.count > 6 {
            for i in 0...4{
                self.incSix.append(self.incAmtPercentage[i])
                self.incCatSix.append(self.incUsedCategories[i])
            }
            var sumAfterSix:Double = 0
            for i in 5...self.incUsedCategories.count-1 {
                sumAfterSix += self.incAmtPercentage[i]
            }
            self.incSix.append(sumAfterSix)
            self.incCatSix.append("Others")
        }else{
            for i in 0...self.incUsedCategories.count-1 {
                self.incSix.append(self.incAmtPercentage[i])
                self.incCatSix.append(self.incUsedCategories[i])
            }
            for i in (self.incUsedCategories.count)...5{
                self.incSix.append(0)
                self.incCatSix.append("Others")
            }
        }
    }
    
    
    
    override init(){
        
        super.init()
    }
    deinit {
        println("BIBillAnalysis deinit")
    }
    
}