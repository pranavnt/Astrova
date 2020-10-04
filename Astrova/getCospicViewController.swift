//
//  getCospicViewController.swift
//  Astrova
//
//  Created by Pranav Teegavarapu on 7/11/20.
//  Copyright © 2020 Pranav Teegavarapu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class getCospicViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePicker : UIImagePickerController?
    var imageSelected = false

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageTextField: UITextField!
    
    
    @IBAction func selectCospicPressed(_ sender: Any) {
        imagePicker?.sourceType = .photoLibrary
        present(imagePicker!, animated: true, completion: nil)
    }
    
    
    @IBAction func cameraPressed(_ sender: Any) {
        imagePicker?.sourceType = .camera
        present(imagePicker!, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            imageSelected = true
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextPressed(_ sender: UIButton) {
        if (imageSelected == true && messageTextField.text != "" ) {
            let message = messageTextField.text
            
            let imagesFolder = Storage.storage().reference().child("images")
            
            if let image = imageView.image{
                //let imageData = UIImage.jpegData(imageView.image!)
                let imgData = image.jpegData(compressionQuality: 0.1)!
                let storageRef = imagesFolder.child("\(NSUUID().uuidString).jpg")
                    storageRef.putData(imgData, metadata: nil, completion: { (metadata, error) in
                    if let error = error {
                        self.presentAlert(alert: error.localizedDescription)
                    } else {
                        // Segue to next view Controller

                        print("success idk")
                        
                        storageRef.downloadURL { url, error in
                          if let error = error {
                            print(error)
                          } else {
                            let downloadURL = url!
                            print(downloadURL)
                            self.performSegue(withIdentifier: "send2people", sender: downloadURL)
                            }
                        }
                        
                    }
                })
            }
            
        } else {
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let downloadURL = sender as? String {
            if let selectVC = segue.destination as? selectRecipientTableViewController {
                selectVC.downloadURL = downloadURL
                selectVC.cospicDescription = messageTextField.text!
            }
        }
    }
    
    func presentAlert(alert:String) {
        let alertVC = UIAlertController(title: "Error", message: alert, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
}
