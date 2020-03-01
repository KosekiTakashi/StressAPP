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
    
    var myLists:MyListData!{
        didSet{
            titleName = myLists.titleNameString
            detail = myLists.detail
            urlString = myLists.urlString
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleNameTextField.delegate = self
        detailTextView.delegate = self
        urlStringTextField.delegate = self
        
        titleNameTextField.text! = titleName
        detailTextView.text! = detail
        urlStringTextField.text! = urlString

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleName = titleNameTextField.text!
        detail = detailTextView.text!
        urlString = urlStringTextField.text!
        
        titleNameTextField.resignFirstResponder()
        detailTextView.resignFirstResponder()
        urlStringTextField.resignFirstResponder()
    }
    
    
    @IBAction func change(_ sender: Any) {
        myLists.changeList(titleName: titleName, detail: detail, urlString: urlString)
        self.navigationController?.popViewController(animated: true)
    }

}
