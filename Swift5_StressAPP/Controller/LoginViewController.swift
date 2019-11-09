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
        
        messageLabel.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
