//
//  BIExpense.swift
//  moneyTracker
//
//  Created by User on 24/05/2015.
//  Copyright (c) 2015 User. All rights reserved.
//

import Foundation
class BIExpense: NSObject {
    let dateComponenets = NSDateComponents()
    var category: String?
    var categoryDetail:String?
    var amounts: Float?
    var receiptImage: NSData?
    var expenseDetail: String?
    // date related for record
    let currentDate = NSDate()
    var currentYear: Int?
    var currentMonth: Int?
    var currentDay: Int?
    var currentHour: Int?
    var currentMinute: Int?
    var currentSecond: Int?
    
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
        currentYear = calendar.component(NSCalendarUnit.CalendarUnitYear, fromDate: currentDate)
        currentMonth = calendar.component(NSCalendarUnit.CalendarUnitMonth, fromDate: currentDate)
        currentDay = calendar.component(NSCalendarUnit.CalendarUnitDay, fromDate: currentDate)
        currentHour = calendar.component(NSCalendarUnit.CalendarUnitHour, fromDate: currentDate)
        currentMinute = calendar.component(NSCalendarUnit.CalendarUnitMinute, fromDate: currentDate)
        currentSecond = calendar.component(NSCalendarUnit.CalendarUnitSecond, fromDate: currentDate)
        category = "aCategoryEx"
        categoryDetail = "aCategoryDetailEx"
        amounts = 336.6
        //NSNumber
        
        super.init()
    }
    func addToDatabase() {
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
        let addSQL = "INSERT INTO Expense(Year,Month,Day,Hour,Minute,Second,Category,CategoryDetail,Amounts,ExpenseDetail) VALUES (\(self.currentYear!),\(self.currentMonth!),\(self.currentDay!),\(self.currentHour!),\(self.currentMinute!),\(self.currentSecond!),'\(self.category!)','\(self.categoryDetail)',\(self.amounts!),'\(self.expenseDetail)')"
        if sqlite3_exec(db, addSQL, nil, nil, nil) == SQLITE_OK {
            println("add to Expense successful")
        }else {
            println("add to Expense failed")
        }
        //Close Database File
        sqlite3_close(db)
    }
    class func removeFromDatabase(dataToRemove data: AnyObject?) {
        let defaultValue = "aCategory"
        //Get Path
        var db: COpaquePointer = nil
        let pathsOfAppDocuments = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let pathOfDatabase = (pathsOfAppDocuments[0] as! String).stringByAppendingString("/BIDatabase")
        println(pathOfDatabase)
        // Open database file, when unexists, create a new database file
        if sqlite3_open(pathOfDatabase, &db) == SQLITE_OK {
            println("Database file has been opened successfully!")
        }else{
            println("Database file failed to open!")
            sqlite3_close(db)
        }
        // Remove From Table: ExpenseCategory
        let removeSQL = "DELETE FROM Expense WHERE expenseCategory = '\(defaultValue)'"
        if sqlite3_exec(db, removeSQL, nil, nil, nil) == SQLITE_OK {
            println("remove successful")
        }else {
            println("remove failed")
        }
        // Close Databse file
        sqlite3_close(db)
    }
    class func createTableInDatabaseIfNotExists() {
        //let defaultValue = "aCategory"
        //Get Path
        var db: COpaquePointer = nil
        let pathsOfAppDocuments = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let pathOfDatabase = (pathsOfAppDocuments[0] as! String).stringByAppendingString("/BIDatabase")
        println(pathOfDatabase)
        // Open database file, when unexists, create a new database file
        if sqlite3_open(pathOfDatabase, &db) == SQLITE_OK {
            println("Database file has been opened successfully!")
        }else{
            println("Database file failed to open!")
            sqlite3_close(db)
        }
        // Create Table: ExpenseCategory
        let createSQL:NSString = "CREATE TABLE IF NOT EXISTS Expense(ID INTEGER PRIMARY KEY AUTOINCREMENT, Year INTEGER, Month INTEGER, Day INTEGER, Hour INTEGER, Minute INTEGER, Second INTEGER,Category TEXT,CategoryDetail TEXT,Amounts REAL, ExpenseDetail TEXT)"
        if sqlite3_exec(db, createSQL.UTF8String, nil, nil, nil) == SQLITE_OK {
            println("create table successful")
        }else {
            println("create table failed")
        }
        //Close Database File
        sqlite3_close(db)
    }
    class func monthSum(year:Int = 2015, month:Int = 5) -> String {
        let sql: String = "SELECT SUM(Amounts) FROM Expense WHERE Year = \(year) AND Month = \(month)"
        if let monthSum:Double = BIQuery(UTF8StringQuery: sql).resultOfQuery() {
            return "-\(monthSum)"
        }else {
            return "-0.00"
        }
    }
    deinit {
        println("BIExpense deinit")
    }
}