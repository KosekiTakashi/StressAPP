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
    @IBOutlet weak var emailTextField: KaedeTextField!
    
    @IBOutlet weak var createDayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.text = UserData.userEmail
        userNameTextField.text = UserData.userName
        createDayLabel.text = "\(UserData.userCreateDay)"
        let ID = UserData.userID
        print(ID)
        
    }
    
    @IBAction func changePressed(_ sender: Any) {
        
        if userNameTextField.text != UserData.userName{
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            
            changeRequest?.displayName = UserData.userName
            changeRequest?.commitChanges(completion: { (error) in
                print(error as Any)
                return
            })
        }
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
