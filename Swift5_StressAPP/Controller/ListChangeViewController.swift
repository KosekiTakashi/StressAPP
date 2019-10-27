//
//  ListChangeViewController.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/10/25.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import UIKit

class ListChangeViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    
    
    @IBOutlet weak var titleNameTextField: UITextField!
    @IBOutlet weak var urlStringTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    
    var titleName : String = ""
    var detail : String = ""
    var urlString : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleNameTextField.delegate = self
        detailTextView.delegate = self
        urlStringTextField.delegate = self
        
        titleNameTextField.text! = titleName
        detailTextView.text! = detail
        urlStringTextField.text! = urlString

        // Do any additional setup after loading the view.
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleName = titleNameTextField.text!
        detail = detailTextView.text!
        urlString = urlStringTextField.text!
        
        titleNameTextField.resignFirstResponder()
        detailTextView.resignFirstResponder()
        urlStringTextField.resignFirstResponder()
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
