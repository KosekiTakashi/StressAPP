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
    
    @IBOutlet weak var userNameTextField: KaedeTextField!
    
    var username : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        userNameTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        username = userNameTextField.text!
        UserDefaults.standard.set(username, forKey: "userName")
        
        userNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        
    }

    
    
    @IBAction func NewCreate(_ sender: Any) {
        
        UserDefaults.standard.set(username, forKey: "userName")
        
        if username == ""{
            print("not")
            return
        }
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil{
                print(error as Any)
            }else{
                print("succees")
                
                
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                
                changeRequest?.displayName = self.userNameTextField.text!
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
