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

class UserViewController: UIViewController {
    @IBOutlet weak var userNameTextField: KaedeTextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var createDayLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeButton.isHidden = true
        userNameTextField.text = UserData.userName
        emailLabel.text = UserData.userEmail
        createDayLabel.text = "\(UserData.userCreateDay)"
        let ID = UserData.userID
        print(ID)
        
    }
    
    @IBAction func changePressed(_ sender: Any) {
        
        if userNameTextField.text != UserData.userName{
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            
            changeRequest?.displayName = userNameTextField.text
            changeRequest?.commitChanges(completion: { (error) in
                print(error as Any)
                return
            })
        }
        print("------------")
        print(UserData.userName)
    }
    
    
    @IBAction func logOutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            
            self.dismiss(animated: true, completion: nil)
            } catch let signOutError as NSError {
              print ("Error signing out: %@", signOutError)
        }
            
    }
    
}
