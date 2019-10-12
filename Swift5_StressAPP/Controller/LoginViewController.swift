//
//  LoginViewController.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/10/09.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import UIKit
import TextFieldEffects

class LoginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var userNameTextField: UITextField!
    
    var username : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameTextField.delegate = self
        
    
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        username = userNameTextField.text!
        UserDefaults.standard.set(username, forKey: "userName")
        
        userNameTextField.resignFirstResponder()
        
    }
    
    
    @IBAction func Action(_ sender: Any) {
        UserDefaults.standard.set(username, forKey: "userName")
        
        performSegue(withIdentifier: "tab", sender: nil)
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
