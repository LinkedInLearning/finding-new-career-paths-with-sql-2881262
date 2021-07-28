//
//  ViewController.swift
//  SQLDemo
//
//  Created by Nikiya Simpson on 7/28/21.
//  Copyright © 2021 Nikiya Simpson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var customerTable : UITableView!
       
       let cellReuseIdentifier = "cell"
       
       var db:DBHelper = DBHelper()
       
       var customers:[Customer] = []
       
       override func viewDidLoad() {
           super.viewDidLoad()
           customerTable.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
           
           customerTable.delegate = self
           customerTable.dataSource = self
           
           db.insert(customerid: 1, firstname: "Nikiya", lastname:"Simpson", email:"ins@example.com")
           db.insert(customerid: 2, firstname: "John", lastname:"Smith", email:"js@example.com")
           db.insert(customerid: 3, firstname: "Jane", lastname:"Doe", email:"jd@example.com")
        
           customers = db.read()
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
       {
           return customers.count
            
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
       {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        
        cell.textLabel?.text = customers[indexPath.row].firstname + " " + customers[indexPath.row].lastname + " Email: " + customers[indexPath.row].email
          
          return cell
       }

}

