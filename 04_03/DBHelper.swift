//
//  DBHelper.swift
//  SQLDemo
//
//  Created by Nikiya Simpson on 7/28/21.
//  Copyright © 2021 Nikiya Simpson. All rights reserved.
//

import Foundation
import SQLite3

class DBHelper
{
    init()
    {
        db = openDatabase()
        createCustomerTable()
    }

    let dbPath: String = "hplussport.sqlite"
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
    
    func createCustomerTable() {
        
        let createCustomerSQL = "CREATE TABLE IF NOT EXISTS customers(CustomerID INTEGER PRIMARY KEY, FirstName TEXT, LastName TEXT,Email TEXT);"
        
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createCustomerSQL, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("Created customers table")
            } else {
                print("Not able to create customers table")
            }
        } else {
            print("CREATE TABLE statement did not run.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    func insert(customerid:Int, firstname:String, lastname:String, email:String)
    {
        let customers = read()
        for c in customers
        {
            if c.customerid == customerid
            {
                print("Customer in Database")
                return
            }
        }
        let insertCustomerString = "INSERT INTO customers(CustomerID, FirstName, LastName, Email) VALUES (?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertCustomerString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(customerid))
            sqlite3_bind_text(insertStatement, 2, (firstname as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (lastname as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (email as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted customer.")
            } else {
                print("Could not insert customer.")
            }
        } else {
            print("INSERT statement did not run.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func read() -> [Customer] {
        let queryStatementString = "SELECT CustomerID, FirstName, LastName, Email FROM customers;"
        var queryStatement: OpaquePointer? = nil
        var customers : [Customer] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let customerid = sqlite3_column_int(queryStatement, 0)
                let firstname = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let lastname = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let email = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                
                customers.append(Customer(customerid: Int(customerid), firstname: firstname, lastname: lastname, email:email))
                //print("Query Result:")
                //print("\(customerid) | \(firstname) | \(lastname) | \(email)")
            }
        } else {
            print("SELECT statement did not run.")
        }
        sqlite3_finalize(queryStatement)
        return customers
    }
    
    func deleteByID(customerid:Int) {
        let deleteCustomerSQL = "DELETE FROM customers WHERE Customerid = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteCustomerSQL, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(customerid))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted customer.")
            } else {
                print("Could not delete customer.")
            }
        } else {
            print("DELETE statement did not run.")
        }
        sqlite3_finalize(deleteStatement)
    }
    
}
