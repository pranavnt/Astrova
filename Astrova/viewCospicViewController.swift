//
//  viewCospicViewController.swift
//  Astrova
//
//  Created by Pranav Teegavarapu on 7/12/20.
//  Copyright © 2020 Pranav Teegavarapu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class viewCospicViewController: UIViewController {

    @IBOutlet weak var messageView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    var cospic: DataSnapshot?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let cospicDictionary = cospic?.value as? NSDictionary {
            if let description = cospicDictionary["description"] as? String {
                if let imageURL = cospicDictionary["imageURL"] as? String {
                    messageView.text = description
                    
                    if let url = URL(string: imageURL){
                        imageView.sd_setImage(with: url)
                    }
                     
                }
            }
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let currentUID = Auth.auth().currentUser?.uid {
            Database.database().reference().child("users").child(currentUID).child("cospics").child(cospic!.key).removeValue()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
