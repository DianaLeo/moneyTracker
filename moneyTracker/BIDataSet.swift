//
//  BIDataSet.swift
//  moneyTracker
//
//  Created by User on 24/05/2015.
//  Copyright (c) 2015 User. All rights reserved.
//

import Foundation
class BIDataSet: NSObject {
    //Singleton Mode, Saved in independent file or database
    
    //Singleton implementation
    static func sharedInstance() -> BIDataSet {
        struct SingletonStruct {
            static var instance:BIDataSet?
            static var dispatchOnceT: dispatch_once_t = 0
        }
        dispatch_once( &SingletonStruct.dispatchOnceT, { () in
            SingletonStruct.instance = BIDataSet()
            println("BIDataSet Singleton Pointer = \(SingletonStruct.instance!)")
        })
        return SingletonStruct.instance!
    }
    
    //Read Data From file or database, if unexists, then create new and save to file or database
    //var db: COpaquePointer = nil
    
    func readFromDatabase() {
        var db: COpaquePointer = nil
        let pathsOfAppDocuments = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let pathOfDatabase = (pathsOfAppDocuments[0] as! String).stringByAppendingString("/BIDatabase")
        //println(pathOfDatabase)
        // open database file, when unexists, create a new database file
        if sqlite3_open(pathOfDatabase, &db) == SQLITE_OK {
            //println("Database file has been opened successfully!")
        }else{
            println("Database file failed to open!")
            sqlite3_close(db)
        }
        
        //read data Of ExpenseCategory
        let readExpenseSQL:NSString = "SELECT * FROM ExpenseCategory"
        var pStmt: COpaquePointer = nil
        if sqlite3_prepare_v2(db, readExpenseSQL.UTF8String, -1, &pStmt, nil) == SQLITE_OK {
            //println("database query goes into prepare!")
            while sqlite3_step(pStmt) == SQLITE_ROW {
                let num = sqlite3_column_int(pStmt, 0)
                let expCate = String.fromCString(UnsafePointer(sqlite3_column_text(pStmt, 1)))
                self.expenseCategory.append(expCate!)
                println("BIDataSet Instance ID = \(num) expenseCategory = \(expCate!)")
            }
            println(self.expenseCategory)
        }else{
            println("database query failed in prepare_v2 stage!")
        }
        sqlite3_finalize(pStmt)
        
        //read data Of IncomeCategory
        let readIncomeSQL:NSString = "SELECT * FROM IncomeCategory"
        sqlite3_close(db)
    }
    func addToDatabase(dataToWrite data: AnyObject?) {
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
        // Add To Table: ExpenseCategory
        let addSQL = "INSERT INTO ExpenseCategory(ExpenseCategory) VALUES ('\(defaultValue)')"
        if sqlite3_exec(db, addSQL, nil, nil, nil) == SQLITE_OK {
            println("add successful")
        }else {
            println("add failed")
        }
        //Close Database File
        sqlite3_close(db)
    }
    func removeFromDatabase(dataToWrite data: AnyObject?) {
        let defaultValue = "aCategory"
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
        // Remove From Table: ExpenseCategory
        let removeSQL = "DELETE FROM ExpenseCategory WHERE ExpenseCategory = '\(defaultValue)'"
        if sqlite3_exec(db, removeSQL, nil, nil, nil) == SQLITE_OK {
            println("remove successful")
        }else {
            println("remove failed")
        }
        // Close Databse file
        sqlite3_close(db)
    }
    //Data
    var expenseCategory: [String] = [] {
        didSet { // write to database when modified
            //writeToDatabase(dataToWrite: oldValue)
        }
        willSet { }
    }
    
    var incomeCategory: [String] = []  {
        didSet { // write to database when modified
            //writeToDatabase(dataToWrite: oldValue)
        }
        willSet { }
    }
    
    override init() {
//        ExpenseCategory = ["Clothing","Food","Accomdation","Travel","Entertainment","Telecommunication"]
//        IncomeCategory =
        super.init()
        //call self method after super.init
        self.readFromDatabase()
    }
    
    
    deinit {
        println("BIDataSet deinit")
    }
    
}