//
//  BIIncome.swift
//  moneyTracker
//
//  Created by User on 24/05/2015.
//  Copyright (c) 2015 User. All rights reserved.
//

import Foundation
class BIIncome:NSObject {
    
    var category: String?
    var categoryDetail:String?
    var amounts: Float?
    var receiptImage: NSData?
    var incomeDetail: String?
    var yearOfIncome:Int
    var monthOfIncome:Int
    var dayOfIncome:Int
    var hourOfIncome:Int
    var minuteOfIncome:Int
    var secondOfIncome:Int
    
    struct IncomeRecord {
        var cat: String
        var catDetl: String
        var amo:Double
        var amoStr:String
        let ID:Int
        init(category:String,categoryDetail:String,amounts:Double,incomeID:Int){
            amo = amounts
            cat = category
            catDetl = categoryDetail
            amoStr = "+\(amo)"
            ID = incomeID
        }
    }
    
    // date related for record
    private let dateComponenets = NSDateComponents()
    private let currentDate = NSDate()
    private var currentYear: Int?
    private var currentMonth: Int?
    private var currentDay: Int?
    private var currentHour: Int?
    private var currentMinute: Int?
    private var currentSecond: Int?
    
    convenience init(year:Int,month:Int,day:Int,category:String, categoryDetail:String?, amounts:Float,incomeDetail:String?,receiptImage:NSData? = nil) {
        self.init()
        self.category = category
        self.categoryDetail = categoryDetail
        self.amounts = amounts
        self.incomeDetail = incomeDetail
        self.receiptImage = receiptImage
        //time related
        self.yearOfIncome = year
        self.monthOfIncome = month
        self.dayOfIncome = day
        
    }
    convenience init(category:String, categoryDetail:String?, amounts:Float,incomeDetail:String?,receiptImage:NSData? = nil) {
        self.init()
        self.category = category
        self.categoryDetail = categoryDetail
        self.amounts = amounts
        self.incomeDetail = incomeDetail
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
        self.yearOfIncome = self.currentYear!
        self.monthOfIncome = self.currentMonth!
        self.dayOfIncome = self.currentDay!
        self.hourOfIncome = self.currentHour!
        self.minuteOfIncome = self.currentMinute!
        self.secondOfIncome = self.currentSecond!
        //need to delete
        category = "DefaultCategory"
        categoryDetail = "DefaultCategoryDetail"
        amounts = 45.6
        //delegate up to super.init
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
        let addSQL = "INSERT INTO Income(Year,Month,Day,Hour,Minute,Second,Category,CategoryDetail,Amounts,IncomeDetail,YearOfIncome,MonthOfIncome,DayOfIncome,HourOfIncome,MinuteOfIncome,SecondOfIncome) VALUES (\(self.currentYear!),\(self.currentMonth!),\(self.currentDay!),\(self.currentHour!),\(self.currentMinute!),\(self.currentSecond!),'\(self.category!)','\(self.categoryDetail)',\(self.amounts!),'\(self.incomeDetail)',\(self.yearOfIncome),\(self.monthOfIncome),\(self.dayOfIncome),\(self.hourOfIncome),\(self.minuteOfIncome),\(self.secondOfIncome))"
        if sqlite3_exec(db, addSQL, nil, nil, nil) == SQLITE_OK {
            println("add to Table:Income successful")
        }else {
            println("add to Table:Income failed")
        }
        //Close Database File
        sqlite3_close(db)
    }
    class func removeFromDatabase(incomeID ID: Int) {
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
        let removeSQL = "DELETE FROM Income WHERE ID = \(ID)"
        if sqlite3_exec(db, removeSQL, nil, nil, nil) == SQLITE_OK {
            println("remove Record: ID = \(ID) from Table: Income successful Or unexists")
        }else {
            println("remove Record: ID = \(ID) from Table: Income failed")
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
        let createSQL:NSString = "CREATE TABLE IF NOT EXISTS Income(ID INTEGER PRIMARY KEY AUTOINCREMENT, Year INTEGER, Month INTEGER, Day INTEGER, Hour INTEGER, Minute INTEGER, Second INTEGER,Category TEXT,CategoryDetail TEXT,Amounts REAL, IncomeDetail TEXT,YearOfIncome INTEGER,MonthOfIncome INTEGER,DayOfIncome INTEGER,HourOfIncome INTEGER,MinuteOfIncome INTEGER,SecondOfIncome INTEGER)"
        if sqlite3_exec(db, createSQL.UTF8String, nil, nil, nil) == SQLITE_OK {
            println("create Table:Income successful")
        }else {
            println("create Table:Income failed")
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
        let dropIncomeSQL: NSString = "DROP TABLE Income"
        if sqlite3_exec(db, dropIncomeSQL.UTF8String, nil, nil, nil) == SQLITE_OK {
            println("drop old Table:Income successful")
        }else{
            println("drop old table:Income failed!")
        }
        //close database file
        sqlite3_close(db)
        
    }
    class func monthSum(#year:Int = 2015, #month:Int = 5) -> String {
        let sql: String = "SELECT SUM(Amounts) FROM Income WHERE Year = \(year) AND Month = \(month)"
        if let monthSum:Double = BIQuery(UTF8StringQuery: sql).resultOfQuery() {
            return "+\(monthSum)"
        }else {
            return "+0.00"
        }
    }
    class func dailyRecords(#year:Int = 2015,#month:Int = 5,#day:Int = 25) -> [IncomeRecord]{
        var incomeRecords: [IncomeRecord] = []
        let IDSQL:String = "SELECT ID FROM Income WHERE YearOfIncome= \(year) AND MonthOfIncome = \(month) AND DayOfIncome = \(day)"
        let categorySQL:String = "SELECT Category FROM Income WHERE YearOfIncome= \(year) AND MonthOfIncome = \(month) AND DayOfIncome = \(day)"
        let categoryDetailSQL:String = "SELECT "
        let amountsSQL: String = "SELECT Amounts FROM Income WHERE YearOfIncome= \(year) AND MonthOfIncome = \(month) AND DayOfIncome = \(day)"
        let recordsID:[Int] = BIQuery(UTF8StringQuery: IDSQL).resultsOfQuery()
        if  recordsID.count != 0 {
            //println(recordsID.count)
            let ids:[Int] = BIQuery(UTF8StringQuery: IDSQL).resultsOfQuery()
            let categoies:[String] = BIQuery(UTF8StringQuery: categorySQL).resultsOfQuery()
            let amountsOfAll:[Double] = BIQuery(UTF8StringQuery: amountsSQL).resultsOfQuery()
            //println("amounts array = \(amountsOfAll)")
            for i in 1...recordsID.count {
                incomeRecords.append(IncomeRecord(category: categoies[i-1], categoryDetail: "BNE", amounts: amountsOfAll[i-1],incomeID: ids[i-1]))
            }
        }else{
            println("No records found in Income for the date provided")
        }
        //println(incomeRecords[1].loc)
        //println(incomeRecords[1].amo)
        return incomeRecords
    }
    deinit {
        self.addToDatabase()
        println("BIIncome deinit")
    }
}