//
//  AddViewController.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/10/07.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import UIKit
import Firebase


class AddViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var URLTextField: UITextField!
    
    @IBOutlet weak var addButton: UIButton!
    
   
    var userName = String()
    var titleName = String()
    var detail = String()
    var urlString = String()
    
    var nameArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.object(forKey: "userName") != nil{
            userName = UserDefaults.standard.object(forKey: "userName") as! String
        }
        
        UserNameLabel.text = userName
        
        titleTextField.delegate = self
        detailTextView.delegate = self
        URLTextField.delegate = self
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.object(forKey: "namearray") != nil{
            nameArray = UserDefaults.standard.object(forKey: "namearray") as! [String]
        }
        
        addButton.isHidden = true
        addButton.isEnabled = false
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleName = titleTextField.text!
        detail = detailTextView.text!
        urlString = URLTextField.text!
        
        if titleName != nil || detail != nil{
            addButton.isHidden = false
            addButton.isEnabled = true
        }
        titleTextField.resignFirstResponder()
        detailTextView.resignFirstResponder()
        URLTextField.resignFirstResponder()
    }
    
    
    
    @IBAction func postAction(_ sender: Any) {
        
        titleName = titleTextField.text!
        detail = detailTextView.text!
        urlString = URLTextField.text!
        
        let timeLineDB = Database.database().reference().child("timeLine").childByAutoId()
        
        let timeLineInfo = ["userName":self.userName as Any , "titleName":self.titleName as Any,"detail": detail as Any,"URL":urlString as Any,"postDate":ServerValue.timestamp()] as [String:Any]
        
        timeLineDB.updateChildValues(timeLineInfo)
        
        
        //自分のリストに追加したい
        nameArray.append(titleName)
        UserDefaults.standard.set(nameArray, forKey: "namearray")
        
        
        titleTextField.text = ""
        detailTextView.text = ""
        URLTextField.text = ""
        
        addButton.isHidden = true
        addButton.isEnabled = false
        
        
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
