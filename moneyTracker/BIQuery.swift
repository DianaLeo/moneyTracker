//
//  BIQuery.swift
//  moneyTracker
//
//  Created by User on 24/05/2015.
//  Copyright (c) 2015 User. All rights reserved.
//

import Foundation
//let queryQueue = dispatch_queue_create("queryQueue", DISPATCH_QUEUE_CONCURRENT)
class BIQuery: NSObject {
    var query: String?
    convenience init(UTF8StringQuery query: String) {
        //call designated init firt
        println("BIQuery will Init")
        self.init()
        //do something more in phase 2
        self.query = query
        //println(self.query)
    }
    override init() {
        //init self property before delegate up
        
        //call super.init
        super.init()
        println("BIQuery Did Init")
    }
    func resultOfQuery() -> Double? {
        var result: Double?
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
            // read data by query
        let readSQL:NSString = self.query!
        var pStmt: COpaquePointer = nil
        if sqlite3_prepare_v2(db, readSQL.UTF8String, -1, &pStmt, nil) == SQLITE_OK {
                //println("database query goes into prepare!")
            while sqlite3_step(pStmt) == SQLITE_ROW {
                //let num = sqlite3_column_int(pStmt, 0)
                //results += String.fromCString(UnsafePointer(sqlite3_column_text(pStmt, 7)))!
                result = sqlite3_column_double(pStmt, 0)
                //println("BIDataSet Instance ID = \(num)")
            }
        }else{
            println("database query failed in prepare_v2 stage!")
        }
        sqlite3_finalize(pStmt)
        sqlite3_close(db)
        //println(results)
        println(result)
        return result
    }
    func resultOfQuery() -> Int? {
        var result: Int?
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
        // read data by query
        let readSQL:NSString = self.query!
        var pStmt: COpaquePointer = nil
        if sqlite3_prepare_v2(db, readSQL.UTF8String, -1, &pStmt, nil) == SQLITE_OK {
            //println("database query goes into prepare!")
            while sqlite3_step(pStmt) == SQLITE_ROW {
                //let num = sqlite3_column_int(pStmt, 0)
                //results += String.fromCString(UnsafePointer(sqlite3_column_text(pStmt, 7)))!
                result = Int(sqlite3_column_int(pStmt, 0))
                //println("BIDataSet Instance ID = \(num)")
            }
        }else{
            println("database query failed in prepare_v2 stage!")
        }
        sqlite3_finalize(pStmt)
        sqlite3_close(db)
        //println(results)
        println(result)
        return result
    }
    func resultOfQuery() -> String? {
        var result: String?
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
        // read data by query
        let readSQL:NSString = self.query!
        var pStmt: COpaquePointer = nil
        if sqlite3_prepare_v2(db, readSQL.UTF8String, -1, &pStmt, nil) == SQLITE_OK {
            //println("database query goes into prepare!")
            while sqlite3_step(pStmt) == SQLITE_ROW {
                //let num = sqlite3_column_int(pStmt, 0)
                result = String.fromCString(UnsafePointer(sqlite3_column_text(pStmt, 7)))!
                //result = sqlite3_column_double(pStmt, 0)
                //println("BIDataSet Instance ID = \(num)")
            }
        }else{
            println("database query failed in prepare_v2 stage!")
        }
        sqlite3_finalize(pStmt)
        sqlite3_close(db)
        //println(results)
        println(result)
        return result
    }
//    func resultOfQuery() -> NSData? {
//        return nil
//    }
    
    deinit {
        println("BIQuery instance did deinit")
    }
    
}