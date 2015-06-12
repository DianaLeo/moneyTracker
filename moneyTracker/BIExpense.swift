//
//  BIExpense.swift
//  moneyTracker
//
//  Created by User on 24/05/2015.
//  Copyright (c) 2015 User. All rights reserved.
//

import Foundation
struct Expense {
    var year:Int = 0
    var month:Int = 0
    var day:Int = 0
    var category:String = ""
    var categoryDetail:String?
    var amount:Float = 0
    var expenseDetail:String = ""
    var receiptImage:NSData?
}
struct ExpenseRecord {
    var cat: String
    var detl: String
    var amo:Double
    var amoStr:String
    let ID:Int
    init(category:String,detail:String,amounts:Double,expenseID:Int){
        amo = amounts
        cat = category
        detl = detail
        amoStr = "\(amo)"
        ID = expenseID
    }
}
class BIExpense: NSObject {
    
    var category: String?
    var categoryDetail:String?
    var amounts: Float?
    var receiptImage: NSData?
    var expenseDetail: String?
    var yearOfExpense:Int
    var monthOfExpense:Int
    var dayOfExpense:Int
    var hourOfExpense:Int
    var minuteOfExpense:Int
    var secondOfExpense:Int
//    struct ExpenseRecord {
//        var cat: String
//        var catDetl: String
//        var amo:Double
//        var amoStr:String
//        let ID:Int
//        init(category:String,categoryDetail:String,amounts:Double,expenseID:Int){
//            amo = amounts
//            cat = category
//            catDetl = categoryDetail
//            amoStr = "-\(amo)"
//            ID = expenseID
//        }
//    }
    
    // date related for record
    private let dateComponenets = NSDateComponents()
    private let currentDate = NSDate()
    private var currentYear: Int?
    private var currentMonth: Int?
    private var currentDay: Int?
    private var currentHour: Int?
    private var currentMinute: Int?
    private var currentSecond: Int?
    
    convenience init(year:Int,month:Int,day:Int,category:String, categoryDetail:String?, amounts:Float,expenseDetail:String?,receiptImage:NSData? = nil) {
        self.init()
        self.category = category
        self.categoryDetail = categoryDetail
        self.amounts = amounts
        self.expenseDetail = expenseDetail ?? ""
        self.receiptImage = receiptImage
        self.yearOfExpense = year
        self.monthOfExpense = month
        self.dayOfExpense = day
    }
    convenience init(category:String, categoryDetail:String?, amounts:Float,expenseDetail:String?,receiptImage:NSData? = nil) {
        self.init()
        self.category = category
        self.categoryDetail = categoryDetail
        self.amounts = amounts
        self.expenseDetail = expenseDetail
        self.receiptImage = receiptImage
    }
    override init() {
        //finish self property init before call super.init.
        var calendar = NSCalendar.currentCalendar()
        self.currentYear = calendar.component(NSCalendarUnit.CalendarUnitYear, fromDate: currentDate)
        self.currentMonth = calendar.component(NSCalendarUnit.CalendarUnitMonth, fromDate: currentDate)
        self.currentDay = calendar.component(NSCalendarUnit.CalendarUnitDay, fromDate: currentDate)
        self.currentHour = calendar.component(NSCalendarUnit.CalendarUnitHour, fromDate: currentDate)
        self.currentMinute = calendar.component(NSCalendarUnit.CalendarUnitMinute, fromDate: currentDate)
        self.currentSecond = calendar.component(NSCalendarUnit.CalendarUnitSecond, fromDate: currentDate)
        self.yearOfExpense = self.currentYear!
        self.monthOfExpense = self.currentMonth!
        self.dayOfExpense = self.currentDay!
        self.hourOfExpense = self.currentHour!
        self.minuteOfExpense = self.currentMinute!
        self.secondOfExpense = self.currentSecond!
        category = "aCategoryEx"
        categoryDetail = "aCategoryDetailEx"
        amounts = 98.3
        //delegete up
        super.init()
        
    }
    private func addToDatabase() {
        //Get Path
        var db: COpaquePointer = nil
        let pathsOfAppDocuments = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let pathOfDatabase = (pathsOfAppDocuments[0] as! String).stringByAppendingString("/BIDatabase")
        //println(pathOfDatabase)
        // Open database file, when unexists, create a new database file
        if sqlite3_open(pathOfDatabase, &db) == SQLITE_OK {
            //println("Database file has been opened successfully!")
        }else{
            println("Database file failed to open!")
            sqlite3_close(db)
        }
        // Add To Table: ExpenseCategory
        let addSQL = "INSERT INTO Expense(Year,Month,Day,Hour,Minute,Second,Category,CategoryDetail,Amounts,ExpenseDetail,YearOfExpense,MonthOfExpense,DayOfExpense,HourOfExpense,MinuteOfExpense,SecondOfExpense) VALUES (\(self.currentYear!),\(self.currentMonth!),\(self.currentDay!),\(self.currentHour!),\(self.currentMinute!),\(self.currentSecond!),'\(self.category!)','\(self.categoryDetail)',\(self.amounts!),'\(self.expenseDetail!)',\(self.yearOfExpense),\(self.monthOfExpense),\(self.dayOfExpense),\(self.hourOfExpense),\(self.minuteOfExpense),\(self.secondOfExpense))"
        if sqlite3_exec(db, addSQL, nil, nil, nil) == SQLITE_OK {
            println("add to Table:Expense successful")
        }else {
            println("add to Table:Expense failed")
        }
        //Close Database File
        sqlite3_close(db)
    }
    class func removeFromDatabase(expenseID ID: Int) {
        //Get Path
        var db: COpaquePointer = nil
        let pathsOfAppDocuments = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let pathOfDatabase = (pathsOfAppDocuments[0] as! String).stringByAppendingString("/BIDatabase")
        //println(pathOfDatabase)
        // Open database file, when unexists, create a new database file
        if sqlite3_open(pathOfDatabase, &db) == SQLITE_OK {
            //println("Database file has been opened successfully!")
        }else{
            println("Database file failed to open!")
            sqlite3_close(db)
        }
        // Remove From Table: ExpenseCategory
        let removeSQL = "DELETE FROM Expense WHERE ID = \(ID)"
        if sqlite3_exec(db, removeSQL, nil, nil, nil) == SQLITE_OK {
            println("remove Record:ID = \(ID) from Table:Expense successful Or unexists")
        }else {
            println("remove Record:ID = \(ID) from Table:Expense failed")
        }
        // Close Databse file
        sqlite3_close(db)
    }
    class func updateToDatabase(expenseID ID: Int,expense:Expense) {
        //Get Path
        var db: COpaquePointer = nil
        let pathsOfAppDocuments = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let pathOfDatabase = (pathsOfAppDocuments[0] as! String).stringByAppendingString("/BIDatabase")
        //println(pathOfDatabase)
        // Open database file, when unexists, create a new database file
        if sqlite3_open(pathOfDatabase, &db) == SQLITE_OK {
            //println("Database file has been opened successfully!")
        }else{
            println("Database file failed to open!")
            sqlite3_close(db)
        }
        // Update Table: IncomeCategory
        let updateSQL = "UPDATE Expense SET Category = '\(expense.category)',CategoryDetail = '\(expense.categoryDetail)',Amounts = \(expense.amount),ExpenseDetail = '\(expense.expenseDetail)',YearOfExpense = \(expense.year),MonthOfExpense = \(expense.month),DayOfExpense = \(expense.day) WHERE ID = \(ID)"
        if sqlite3_exec(db, updateSQL, nil, nil, nil) == SQLITE_OK {
            println("update Record: ID = \(ID) into Table: Expense successful Or unexists")
        }else {
            println("update Record: ID = \(ID) into Table: Expense failed")
        }
        // Close Databse file
        sqlite3_close(db)
    }
    class func createTableInDatabaseIfNotExists() {
        //Get Path
        var db: COpaquePointer = nil
        let pathsOfAppDocuments = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let pathOfDatabase = (pathsOfAppDocuments[0] as! String).stringByAppendingString("/BIDatabase")
        //println(pathOfDatabase)
        // Open database file, when unexists, create a new database file
        if sqlite3_open(pathOfDatabase, &db) == SQLITE_OK {
            println("Database file has been opened successfully!")
        }else{
            println("Database file failed to open!")
            sqlite3_close(db)
        }
        // Create Table: ExpenseCategory
        let createSQL:NSString = "CREATE TABLE IF NOT EXISTS Expense(ID INTEGER PRIMARY KEY AUTOINCREMENT, Year INTEGER, Month INTEGER, Day INTEGER, Hour INTEGER, Minute INTEGER, Second INTEGER,Category TEXT,CategoryDetail TEXT,Amounts REAL, ExpenseDetail TEXT,YearOfExpense INTEGER,MonthOfExpense INTEGER,DayOfExpense INTEGER,HourOfExpense INTEGER,MinuteOfExpense INTEGER,SecondOfExpense INTEGER)"
        if sqlite3_exec(db, createSQL.UTF8String, nil, nil, nil) == SQLITE_OK {
            println("create Table:Expense successful")
        }else {
            println("create Table:Expense failed")
        }
        //Close Database File
        sqlite3_close(db)
    }
    class func deleteTableInDatabase(){
        var db: COpaquePointer = nil
        let pathsOfAppDocuments = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let pathOfDatabase = (pathsOfAppDocuments[0] as! String).stringByAppendingString("/BIDatabase")
        println(pathOfDatabase)
        
        // open database file, when unexists, create a new database file
        if sqlite3_open(pathOfDatabase, &db) == SQLITE_OK {
            println("Database file has been opened successfully!")
        }else{
            println("Database file failed to open!")
            sqlite3_close(db)
        }
        //drop tables: ExpenseCategory IncomeCategory
        let dropExpenseSQL: NSString = "DROP TABLE Expense"
        if sqlite3_exec(db, dropExpenseSQL.UTF8String, nil, nil, nil) == SQLITE_OK {
            println("drop old Table:Expense successful")
        }else{
            println("drop old table:Expense failed!")
        }
        //close database file
        sqlite3_close(db)
        
    }
    class func monthSum(#year:Int = 2015, #month:Int = 5) -> String {
        let sql: String = "SELECT SUM(Amounts) FROM Expense WHERE YearOfExpense = \(year) AND MonthOfExpense = \(month)"
        if let monthSum:Double = BIQuery(UTF8StringQuery: sql).resultOfQuery() {
            println("\(monthSum)")
            return "-\(monthSum)"
        }else {
            return "-0.00"
        }
    }
    class func dailyRecords(#year:Int = 2015,#month:Int = 5,#day:Int = 28) -> [ExpenseRecord]{
        var expenseRecords: [ExpenseRecord] = []
        let IDSQL:String = "SELECT ID FROM Expense WHERE YearOfExpense= \(year) AND MonthOfExpense = \(month) AND DayOfExpense = \(day)"
        let categorySQL:String = "SELECT Category FROM Expense WHERE YearOfExpense= \(year) AND MonthOfExpense = \(month) AND DayOfExpense = \(day)"
        let expenseDetailSQL:String = "SELECT ExpenseDetail From Expense WHERE YearOfExpense= \(year) AND MonthOfExpense = \(month) AND DayOfExpense = \(day)"
        let amountsSQL: String = "SELECT Amounts FROM Expense WHERE YearOfExpense= \(year) AND MonthOfExpense = \(month) AND DayOfExpense = \(day)"
        let recordsID:[Int] = BIQuery(UTF8StringQuery: IDSQL).resultsOfQuery()
        if  recordsID.count != 0 {
            //println(recordsID.count)
            let ids:[Int] = BIQuery(UTF8StringQuery: IDSQL).resultsOfQuery()
            let categoies:[String] = BIQuery(UTF8StringQuery: categorySQL).resultsOfQuery()
            let expenseDetail:[String] = BIQuery(UTF8StringQuery: expenseDetailSQL).resultsOfQuery()
            let amountsOfAll:[Double] = BIQuery(UTF8StringQuery: amountsSQL).resultsOfQuery()
            //println("amounts array = \(amountsOfAll)")
            for i in 1...recordsID.count {
                expenseRecords.append(ExpenseRecord(category: categoies[i-1], detail: expenseDetail[i-1] ?? "", amounts: amountsOfAll[i-1],expenseID:ids[i-1]))
            }
        }else{
            //println("No records found in Income for the date provided")
        }
        //println(expenseRecords[1].loc)
        //println(expenseRecords[1].amo)
        return expenseRecords
    }
    deinit {
        self.addToDatabase()
        println("BIExpense deinit")
    }
}