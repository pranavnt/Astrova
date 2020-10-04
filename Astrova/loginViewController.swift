//
//  ViewController.swift
//  Astrova
//
//  Created by Pranav Teegavarapu on 7/11/20.
//  Copyright © 2020 Pranav Teegavarapu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class loginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var signupMode: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func topTapped(_ sender: UIButton) {
        if let email = emailTextField.text {
            if let password = passwordTextField.text{
                if (signupMode==true) {
                    Auth.auth().createUser(withEmail: email, password: password) { user, error in
                        if let user = user {
                            if true {
                                if let userID = Auth.auth().currentUser?.uid {
                                    if let userEmail = Auth.auth().currentUser?.email {
                                        Database.database().reference().child("users").child(userID).child("email").setValue(userEmail)
                                        self.performSegue(withIdentifier: "move2snaps", sender: nil)
                                    }
                                }
                            }
                            self.performSegue(withIdentifier: "move2snaps", sender: nil)
                            }
                        }

                    } else {
                    Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                      guard let strongSelf = self else { return }
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            print("login worked")

                            self!.performSegue(withIdentifier: "move2snaps", sender: nil)
                            
                        }
                      // ...
                    }

                    }
                }
            }
        }

    
    @IBAction func bottomTapped(_ sender: UIButton) {
        if (signupMode==true) {
            //switch to login
            signupMode = false
            loginButton.setTitle("Login", for: .normal)
            signupButton.setTitle("Switch to Sign Up", for: .normal)
        } else {
            //switch to signup
            signupMode = true
            loginButton.setTitle("Sign Up", for: .normal)
            signupButton.setTitle("Switch to Login", for: .normal)
        }
    }
    
    
}

