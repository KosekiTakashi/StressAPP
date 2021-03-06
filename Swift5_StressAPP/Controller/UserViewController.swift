//
//  UserViewController.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/12/02.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import UIKit
import Firebase
import TextFieldEffects
import SDWebImage

class UserViewController: UIViewController {
    @IBOutlet weak var userNameTextField: KaedeTextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var createDayLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    
    let userData = UserData()
    let userImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeButton.isHidden = false
        if let userName = (Auth.auth().currentUser?.displayName){
            userNameTextField.text = userName
        }
        
        
        if let userEmail = (Auth.auth().currentUser?.email){
            emailLabel.text = userEmail
        }
        
        if let userCreateDay = (Auth.auth().currentUser?.metadata.creationDate){
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: userCreateDay)
            createDayLabel.text = dateString
        }
        if let userID = (Auth.auth().currentUser?.uid){
            let imageURL = userData.userImageURL(userID: userID)
            if imageURL == "NoName"{
                logoImageView.image = UIImage(named: "noimage")!
            }else{
                logoImageView.sd_setImage(with: URL(string: imageURL), completed: nil)
            }
        }
        
        
        
        
        logoImageView.layer.cornerRadius = logoImageView.frame.height / 2
        
    }
    
    @IBAction func changePressed(_ sender: Any) {
        let userData = UserData()
        let userID = userData.userID()
        let userName = userData.userName()
        if userNameTextField.text != userName{
            
            UserDefaults.standard.set(userNameTextField.text!, forKey: "userName\(userID)")
            
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            if userNameTextField.text != nil{
                changeRequest?.displayName = userNameTextField.text
                changeRequest?.commitChanges(completion: { (error) in
                    print(error as Any)
                    return
                })
            }
        }
    }
    
    
    @IBAction func logOutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            
        } catch let signOutError as NSError {
              print ("Error signing out: %@", signOutError)
        }
            
    }
    
}
