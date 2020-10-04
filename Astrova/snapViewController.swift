//
//  snapViewController.swift
//  Astrova
//
//  Created by Pranav Teegavarapu on 7/11/20.
//  Copyright © 2020 Pranav Teegavarapu. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase


class snapViewController: UITableViewController {
    
    var cospicsArr: [DataSnapshot] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUID = Auth.auth().currentUser?.uid {
            Database.database().reference().child("users").child(currentUID).child("cospics").observe(.childAdded) { (snapshot) in
                self.cospicsArr.append(snapshot)
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cospicsArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let cospicNow = cospicsArr[indexPath.row]
        
        if let cospicDictionary = cospicNow.value as? NSDictionary {
            if let email = cospicDictionary["from"] as? String {
                cell.textLabel?.text = email
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cospicIndex = cospicsArr[indexPath.row]
        
        performSegue(withIdentifier: "viewCospic", sender: cospicIndex)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewCospic"{
            if let viewVC = segue.destination as? viewCospicViewController {
                if let cospic = sender as? DataSnapshot {
                    viewVC.cospic = cospic
                }
            }
        }
        
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        try? Auth.auth().signOut()
    }
    

}
