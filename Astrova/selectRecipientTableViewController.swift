//
//  selectRecipientTableViewController.swift
//  Astrova
//
//  Created by Pranav Teegavarapu on 7/11/20.
//  Copyright © 2020 Pranav Teegavarapu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class selectRecipientTableViewController: UITableViewController {
    
    var downloadURL = ""
    var users: [User] = []
    var cospicDescription = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        print(downloadURL)
        print(";)")
        
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            let user = User()
            if let userDictionary = snapshot.value as? NSDictionary {
                if let email = userDictionary["email"] as? String {
                    user.email = email
                    user.uid = snapshot.key
                    self.users.append(user)
                    self.tableView.reloadData()
                }
            }
            
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let user = users[indexPath.row]
        
        cell.textLabel?.text = user.email

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        
        if let fromEmail = Auth.auth().currentUser?.email {
            let cospicDict = ["from":fromEmail, "description": cospicDescription, "imageURL": downloadURL]
            
            Database.database().reference().child("users").child(user.uid).child("cospics").childByAutoId().setValue(cospicDict)
            
            navigationController?.popToRootViewController(animated: true)
        }
        
    }
}

class User {
    var email = ""
    var uid = ""
}
