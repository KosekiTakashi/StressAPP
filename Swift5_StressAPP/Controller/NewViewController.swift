//
//  NewViewController.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/10/21.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import UIKit
import TextFieldEffects
import Firebase

class NewViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: KaedeTextField!
    @IBOutlet weak var passwordTextField: KaedeTextField!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    var username : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        messageLabel.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
                   
       }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }

    
    
    @IBAction func NewCreate(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil{
                print(error as Any)
                self.messageLabel.isHidden = false
            }else{
                print("succees")
                
                self.performSegue(withIdentifier: "userInput", sender: nil)
            }
        }
    }
}
