//
//  LoginViewController.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/10/09.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import UIKit
import TextFieldEffects
import Firebase

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: KaedeTextField!
    @IBOutlet weak var passwordTextField: KaedeTextField!
    
    @IBOutlet weak var messageLabel: UILabel!
    var username : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.text = "takashi1113@gmail.com"
        passwordTextField.text = "takashi1113"
        
        messageLabel.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }

    

    @IBAction func login(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil{
                print(error as Any)
                self.messageLabel.isHidden = false
            }else{
                print("succees")
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                
                
                changeRequest?.commitChanges(completion: { (error) in
                    print(error as Any)
                    return
                })
                
                self.performSegue(withIdentifier: "tab", sender: nil)
            }
        }
    }

}
