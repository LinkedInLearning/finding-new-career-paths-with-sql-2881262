//
//  Customer.swift
//  SQLDemo
//
//  Created by Nikiya Simpson on 7/28/21.
//  Copyright © 2021 Nikiya Simpson. All rights reserved.
//

import Foundation

class Customer
{
    
    var firstname: String = ""
    var lastname: String = ""
    var email: String = ""
    var customerid: Int = 0
    
    
    init(customerid:Int,firstname:String, lastname:String,email:String)
    {
        self.customerid = customerid
        self.firstname = firstname
        self.lastname = lastname
        self.email = email
    }
}
