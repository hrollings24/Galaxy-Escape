//
//  DBHelper.swift
//  Galaxy Escape
//
//  Created by Harry Rollings on 01/03/2020.
//  Copyright © 2020 Harry Rollings. All rights reserved.
//

import Foundation
import SQLite3

class DBHelper
{
    init()
    {
        db = openDatabase()
        createTable()
    }

    let dbPath: String = "achievementDB.sqlite"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS achievement(id INTEGER PRIMARY KEY,name TEXT,barrier INTEGER, progress INTEGER, description TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("achievement table created.")
            } else {
                print("achievement table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    func insert(id:Int, name:String, barrier:Int, progress:Int, description: String)
    {
        let achievements = read(statement: "SELECT * FROM achievement;")
        for a in achievements
        {
            if a.id == id
            {
                return
            }
        }
        let insertStatementString = "INSERT INTO achievement (id, name, barrier, progress, description) VALUES (NULL, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 2, Int32(barrier))
            sqlite3_bind_int(insertStatement, 3, Int32(progress))
            sqlite3_bind_text(insertStatement, 4, (description as NSString).utf8String, -1, nil)

            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func read(statement: String) -> [Achievement] {
        let queryStatementString = statement
        var queryStatement: OpaquePointer? = nil
        var achvs : [Achievement] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let barrier = sqlite3_column_int(queryStatement, 2)
                let progress = sqlite3_column_int(queryStatement, 3)
                let description = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))

                achvs.append(Achievement(id: Int(id), name: name, barrier: Int(barrier), progress: Int(progress), description: description))
                print("Query Result:")
                print("\(id) | \(name) | \(barrier) | \(progress) | \(description)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return achvs
    }
    
    func update(updateStatementString: String) {
      var updateStatement: OpaquePointer?
      if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) ==
          SQLITE_OK {
        if sqlite3_step(updateStatement) == SQLITE_DONE {
          print("\nSuccessfully updated row.")
        } else {
          print("\nCould not update row.")
        }
      } else {
        print("\nUPDATE statement is not prepared")
      }
      sqlite3_finalize(updateStatement)
    }
}
