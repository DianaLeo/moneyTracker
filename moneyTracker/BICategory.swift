//
//  BIDataSet.swift
//  moneyTracker
//
//  Created by User on 24/05/2015.
//  Copyright (c) 2015 User. All rights reserved.
//

import Foundation
extension Array{
    func substract<Tp:Equatable>(array ary: Array<T>,firstItemInArray elementForType:Tp?) -> Array<T>{
        var differenceArray = self.filter({ (elmtInSelf) -> Bool in
            return !ary.hasItem(elmtInSelf, sameItem: elmtInSelf as? Tp)
        })
        return differenceArray
    }
    func hasItem<Tp:Equatable>(item:T,sameItem:Tp?) -> Bool{
        for itm in self {
            if (itm as! Tp) == (item as! Tp) {
                return true
            }
        }
        return false
    }
}
typealias CategoryImagePath = String
struct BICategoryImagePath {
    static var Clothing:CategoryImagePath = "clothing"
    static var Food:CategoryImagePath = "food"
    static var Accommodation:CategoryImagePath = "accommodation" // should be accomdation
    static var Travel:CategoryImagePath = "Travel"
    static var Transport:CategoryImagePath = "transport"
    static var Telecommnication:CategoryImagePath = "commnication"
    static var Entertainment:CategoryImagePath = "entertainment"
    static var Grocery:CategoryImagePath = "grocery"
    static var Luxury:CategoryImagePath = "luxury"
    static var Gift:CategoryImagePath = "gift"
    static var Health:CategoryImagePath = "health"
    static var MakeUp:CategoryImagePath = "makeup"
    
    
    static var PartTime:CategoryImagePath = "PartTime"
    static var LuckyMoney:CategoryImagePath = "luckyMoney"
    static var Wage:CategoryImagePath = "Wage"
    static var Scholarship:CategoryImagePath = "Scholarship"
    static var Rent:CategoryImagePath = "Rent"
    
    static var Default:CategoryImagePath = "blankCategory"
    
    
}
class BICategory: NSObject {
    //Singleton Mode, Saved in independent file or database
    
    //Singleton implementation
    static func sharedInstance() -> BICategory {
        struct SingletonStruct {
            static var instance:BICategory?
            static var dispatchOnceT: dispatch_once_t = 0
        }
        dispatch_once( &SingletonStruct.dispatchOnceT, { () in
            SingletonStruct.instance = BICategory()
            println("BICategory Singleton Pointer = \(SingletonStruct.instance!)")
        })
        return SingletonStruct.instance!
    }
    
    //Categories and their associated image path
    // rmOrAddFlag false Remove, true Add
    private var rmOrAddFlag:Bool = false // false means rm, true means true
    //Temp expenseCategories and incomeCategories for Init to avoid call addToDatabase by using property observer. Actually the addToDatabase method will fail, but that is because database file is already opened by loadFromDatabase method. Here still choose to use a temp [String] to protect property observer to call addToDatabase, which might be a waste of resourse, or a potential bug.
    private var tmpExCategories: [String] = []
    private var tmpInCategories: [String] = []
    //expenseCategories
    var expenseCategories: [String] = [] {
        didSet { // sync to database when modified
            if self.rmOrAddFlag == false {
                //rm manipulation in database
                let categoryToRemove = oldValue.substract(array: self.expenseCategories, firstItemInArray: self.expenseCategories.first).first
                self.removeFromDatabase(category: categoryToRemove!, fromCategoriesTable: "ExpenseCategory")
            }else {
                //add to database, check if duplicate/repeat
                if oldValue.hasItem(self.expenseCategories.last!, sameItem: self.expenseCategories.last!) {
                    self.expenseCategories.removeLast()
                }else{
                    self.addToDatabase(category: self.expenseCategories.last!, toCategoriesTable: "ExpenseCategory",associatedImagePath:self.choosedAssociatedImagePath)
                }
            }
        }
        willSet {
            if newValue.count < self.expenseCategories.count {
                self.rmOrAddFlag = false // rm manipulation
            }else {
                self.rmOrAddFlag = true // add manipulation
            }
        }
        
    }
    //IncomeCategories
    var incomeCategories: [String] = []  {
        didSet { // sync to database when modified
            if self.rmOrAddFlag == false {
                let categoryToRemove = oldValue.substract(array: self.incomeCategories, firstItemInArray: self.incomeCategories.first).first
                self.removeFromDatabase(category: categoryToRemove!, fromCategoriesTable: "IncomeCategory")
            }else{
                //add to database, check if duplicate/repeat
                if oldValue.hasItem(self.incomeCategories.last!, sameItem: self.incomeCategories.last) {
                    self.incomeCategories.removeLast()
                }else{
                    self.addToDatabase(category: self.incomeCategories.last!, toCategoriesTable: "IncomeCategory",associatedImagePath:self.choosedAssociatedImagePath)
                }
            }
        }
        willSet {
            if newValue.count < self.expenseCategories.count {
                self.rmOrAddFlag = false // rm manipulation
            }else {
                self.rmOrAddFlag = true // add manipualtion
            }
        }
    }
    //choosed associatedPath, BICategoryImagePath.some
    var choosedAssociatedImagePath:CategoryImagePath = BICategoryImagePath.Default
    
    //get image path associated with a certain category in either expenseCategories OR incomeCategories
    func associatedImagePathFor(#category: String) -> String? {
        var categories = ""
        for cateInExpenseCategories in self.expenseCategories {
            if cateInExpenseCategories == category {
                categories = "ExpenseCategory"
                break
            }
        }
        for cateInExpenseCategories in self.incomeCategories {
            if cateInExpenseCategories == category {
                categories = "IncomeCategory"
                break
            }
        }
        let imagePathSQL:String = "SELECT AssociatedImagePath FROM \(categories) WHERE \(categories) = '\(category)'"
        //println(categories)
        //println(imagePathSQL)
        let imagePath:String? = BIQuery(UTF8StringQuery: imagePathSQL).resultOfQuery()
        return imagePath
    }
    //load Data From file or database, if unexists, then create new and save to file or database
    private func loadFromDatabase() {
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
        
        //load data Of ExpenseCategories
        let readExpenseSQL:NSString = "SELECT * FROM ExpenseCategory"
        var pStmt: COpaquePointer = nil
        if sqlite3_prepare_v2(db, readExpenseSQL.UTF8String, -1, &pStmt, nil) == SQLITE_OK {
            //println("database query goes into prepare!")
            while sqlite3_step(pStmt) == SQLITE_ROW {
                let num = sqlite3_column_int(pStmt, 0)
                let expCate = String.fromCString(UnsafePointer(sqlite3_column_text(pStmt, 1)))
                self.tmpExCategories.append(expCate!)
                //println("BICategory Instance ID = \(num) expenseCategory = \(expCate!)")
            }
            println("load data \(self.tmpExCategories)")
        }else{
            println("database query failed in prepare_v2 stage when get data from ExpenseCategory!")
        }
        sqlite3_finalize(pStmt)
        
        //load data Of IncomeCategories
        let readIncomeSQL:NSString = "SELECT * FROM IncomeCategory"
        var pStmtForIncome: COpaquePointer = nil
        if sqlite3_prepare_v2(db, readIncomeSQL.UTF8String, -1, &pStmtForIncome, nil) == SQLITE_OK {
            //println("database query goes into prepare!")
            while sqlite3_step(pStmtForIncome) == SQLITE_ROW {
                let num = sqlite3_column_int(pStmtForIncome, 0)
                let incCate = String.fromCString(UnsafePointer(sqlite3_column_text(pStmtForIncome, 1)))
                self.tmpInCategories.append(incCate!)
                //println("BICategory Instance ID = \(num) incomeCategory = \(incCate!)")
            }
            println("load data \(self.tmpInCategories)")
        }else{
            println("database query failed in prepare_v2 stage when get data from IncomeCategory!")
        }
        sqlite3_finalize(pStmtForIncome)
        
        //close datebase file
        sqlite3_close(db)
    }
    //add new to tables
    private func addToDatabase(#category: String, toCategoriesTable tableName: String,associatedImagePath:String) {
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
        // Add To Table:
        let colunmName = tableName
        let addSQL = "INSERT INTO \(tableName)(\(colunmName),AssociatedImagePath) VALUES ('\(category)','\(associatedImagePath)')"
        //println(addSQL)
        if sqlite3_exec(db, addSQL, nil, nil, nil) == SQLITE_OK {
            println("add to Table: \(tableName) successful")
        }else {
            println("add to Table: \(tableName) failed")
        }
        //Close Database File
        sqlite3_close(db)
    }
    //remove from tables
    private func removeFromDatabase(#category: String, fromCategoriesTable tableName: String) {
        //let defaultValue = "aCategory"
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
        let removeSQL = "DELETE FROM \(tableName) WHERE ExpenseCategory = '\(category)'"
        if sqlite3_exec(db, removeSQL, nil, nil, nil) == SQLITE_OK {
            println("remove \(category) from Table : \(tableName) successful")
        }else {
            println("remove \(category) from Table : \(tableName)failed")
        }
        // Close Databse file
        sqlite3_close(db)
    }
    
    override init() {
        super.init()
        //call self method after super.init
        self.loadFromDatabase()
        if self.tmpExCategories.count == 0 && self.tmpInCategories.count == 0{
            //println("tmp ex . count = 0")
            insertDefaultDatabaseOnceIfNotExists()
            self.loadFromDatabase()
        }
        self.expenseCategories = self.tmpExCategories
        self.incomeCategories = self.tmpInCategories
        //println(self.expenseCategories)
    }
    deinit {
        println("BICategory deinit")
    }
    
}
func createDatabaseOnceIfNotExists() {
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
    
    // drop old table
    //    let dropExpenseCategorySQL: NSString = "DROP TABLE ExpenseCategory"
    //    if sqlite3_exec(db, dropExpenseCategorySQL.UTF8String, nil, nil, nil) == SQLITE_OK {
    //        println("drop old Table:ExpenseCategory successful")
    //    }else{
    //        println("drop old table:ExpenseCategory failed!")
    //    }
    //    let dropIncomeCategorySQL: NSString = "DROP TABLE IncomeCategory"
    //    if sqlite3_exec(db, dropIncomeCategorySQL.UTF8String, nil, nil, nil) == SQLITE_OK {
    //        println("drop old Table:IncomeCategory successful")
    //    }else{
    //        println("drop old Table:IncomeCategory failed!")
    //    }
    
    // check if BIDataSet Tables exists, if not, create new
    let createExpenseCategorySQL: NSString = "CREATE TABLE IF NOT EXISTS ExpenseCategory(ID INTEGER PRIMARY KEY AUTOINCREMENT, ExpenseCategory TEXT,AssociatedImagePath TEXT)"
    if sqlite3_exec(db, createExpenseCategorySQL.UTF8String, nil, nil, nil) == SQLITE_OK {
        println("create new BIDataSet Table or already has an table!")
    }else{
        println("BIDataSet Table failed to create!")
    }
    let createIncomeCategorySQL: NSString = "CREATE TABLE IF NOT EXISTS IncomeCategory(ID INTEGER PRIMARY KEY AUTOINCREMENT, IncomeCategory TEXT,AssociatedImagePath TEXT)"
    if sqlite3_exec(db, createIncomeCategorySQL.UTF8String, nil, nil, nil) == SQLITE_OK {
        println("create new BIDataSet Table or already has an table!")
    }else{
        println("BIDataSet Table failed to create!")
    }
    //insert default data to table
//    let expenseCategories = ["Clothing","Food","Accomdation","Transport","Entertainment","Grocery","Luxury"]
//    let associatedImagePathsForExpenseCategories = [BICategoryImagePath.Clothing,BICategoryImagePath.Food,BICategoryImagePath.Accomdation,BICategoryImagePath.Transport,BICategoryImagePath.Entertainment,BICategoryImagePath.Grocery,BICategoryImagePath.Luxury];
//    var i = 0
//    for expenseCategory in expenseCategories {
//        let insertSQL:NSString = "REPLACE INTO ExpenseCategory(ExpenseCategory,AssociatedImagePath) VALUES('\(expenseCategory)','\(associatedImagePathsForExpenseCategories[i])')"
//        if sqlite3_exec(db, insertSQL.UTF8String, nil, nil, nil) == SQLITE_OK {
//            println("insert \(expenseCategory) to Table: ExpenseCategory successful!")
//        }else {
//            println("insert \(expenseCategory ) to Table: ExpenseCategory failed!")
//        }
//        i++
//    }
//    i = 0
//    let incomeCategories = ["PartTime","LuckyMoney","Wage","Scholarship","Rent"]
//    let associatedImagePathsForIncomeCategories = [BICategoryImagePath.PartTime,BICategoryImagePath.LuckyMoney,BICategoryImagePath.Wage,BICategoryImagePath.Scholarship,BICategoryImagePath.Rent]
//    for incomeCategory in incomeCategories {
//        let insertSQL:NSString = "INSERT INTO IncomeCategory(IncomeCategory,AssociatedImagePath) VALUES('\(incomeCategory)','\(associatedImagePathsForIncomeCategories[i])')"
//        if sqlite3_exec(db, insertSQL.UTF8String, nil, nil, nil) == SQLITE_OK {
//            println("insert \(incomeCategory) to Table: IncomeCategory successful!")
//        }else {
//            println("insert \(incomeCategory) to Table: IncomeCategory failed!")
//        }
//        i++
//    }
    
    // create Table:Income and Table:Expense when unexists.
    BIIncome.createTableInDatabaseIfNotExists()
    BIExpense.createTableInDatabaseIfNotExists()
    
    
    //read data for test
    //        let readSQL:NSString = "SELECT * FROM ExpenseCategory"
    //        var pStmt: COpaquePointer = nil
    //        if sqlite3_prepare_v2(db, readSQL.UTF8String, -1, &pStmt, nil) == SQLITE_OK {
    //            println("database query goes into prepare!")
    //            while sqlite3_step(pStmt) == SQLITE_ROW {
    //                let num = sqlite3_column_int(pStmt, 0)
    //                let expenseCategory = String.fromCString(UnsafePointer(sqlite3_column_text(pStmt, 1)))
    //                println("ID = \(num) expenseCategory = \(expenseCategory!)")
    //            }
    //        }else{
    //            println("database query failed in prepare_v2 stage!")
    //        }
    //        sqlite3_finalize(pStmt)
    
    
    //close database
    sqlite3_close(db)
}
func insertDefaultDatabaseOnceIfNotExists() {
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
    //create new if not exists
    let createExpenseCategorySQL: NSString = "CREATE TABLE IF NOT EXISTS ExpenseCategory(ID INTEGER PRIMARY KEY AUTOINCREMENT, ExpenseCategory TEXT,AssociatedImagePath TEXT)"
    if sqlite3_exec(db, createExpenseCategorySQL.UTF8String, nil, nil, nil) == SQLITE_OK {
        println("create new BIDataSet Table or already has an table!")
    }else{
        println("BIDataSet Table failed to create!")
    }
    let createIncomeCategorySQL: NSString = "CREATE TABLE IF NOT EXISTS IncomeCategory(ID INTEGER PRIMARY KEY AUTOINCREMENT, IncomeCategory TEXT,AssociatedImagePath TEXT)"
    if sqlite3_exec(db, createIncomeCategorySQL.UTF8String, nil, nil, nil) == SQLITE_OK {
        println("create new BIDataSet Table or already has an table!")
    }else{
        println("BIDataSet Table failed to create!")
    }
    //insert default data to table
    let expenseCategories = ["Clothing","Food","Accommodation","Transport","Entertainment","Grocery","Luxury"]
    let associatedImagePathsForExpenseCategories = [BICategoryImagePath.Clothing,BICategoryImagePath.Food,BICategoryImagePath.Accommodation,BICategoryImagePath.Transport,BICategoryImagePath.Entertainment,BICategoryImagePath.Grocery,BICategoryImagePath.Luxury];
    var i = 0
    for expenseCategory in expenseCategories {
        let insertSQL:NSString = "REPLACE INTO ExpenseCategory(ExpenseCategory,AssociatedImagePath) VALUES('\(expenseCategory)','\(associatedImagePathsForExpenseCategories[i])')"
        if sqlite3_exec(db, insertSQL.UTF8String, nil, nil, nil) == SQLITE_OK {
            println("insert \(expenseCategory) to Table: ExpenseCategory successful!")
        }else {
            println("insert \(expenseCategory ) to Table: ExpenseCategory failed!")
        }
        i++
    }
    i = 0
    let incomeCategories = ["PartTime","LuckyMoney","Wage","Scholarship","Rent"]
    let associatedImagePathsForIncomeCategories = [BICategoryImagePath.PartTime,BICategoryImagePath.LuckyMoney,BICategoryImagePath.Wage,BICategoryImagePath.Scholarship,BICategoryImagePath.Rent]
    for incomeCategory in incomeCategories {
        let insertSQL:NSString = "INSERT INTO IncomeCategory(IncomeCategory,AssociatedImagePath) VALUES('\(incomeCategory)','\(associatedImagePathsForIncomeCategories[i])')"
        if sqlite3_exec(db, insertSQL.UTF8String, nil, nil, nil) == SQLITE_OK {
            println("insert \(incomeCategory) to Table: IncomeCategory successful!")
        }else {
            println("insert \(incomeCategory) to Table: IncomeCategory failed!")
        }
        i++
    }
    sqlite3_close(db)
}
func deleteDatabase() {
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
    let dropExpenseCategorySQL: NSString = "DROP TABLE ExpenseCategory"
    if sqlite3_exec(db, dropExpenseCategorySQL.UTF8String, nil, nil, nil) == SQLITE_OK {
        println("drop old Table:ExpenseCategory successful")
    }else{
        println("drop old table:ExpenseCategory failed!")
    }
    let dropIncomeCategorySQL: NSString = "DROP TABLE IncomeCategory"
    if sqlite3_exec(db, dropIncomeCategorySQL.UTF8String, nil, nil, nil) == SQLITE_OK {
        println("drop old Table:IncomeCategory successful")
    }else{
        println("drop old Table:IncomeCategory failed!")
    }
    //close database file
    sqlite3_close(db)
}

