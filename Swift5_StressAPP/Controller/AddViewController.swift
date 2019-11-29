//
//  AddViewController.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/10/07.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift
import Lottie

class AddViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var URLTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
   
    var userName = String()
    var userID = String()
    var titleName = String()
    var detail = String()
    var urlString = String()
    var mylistArray = [String]()
    var count = Int()
    var goodUser = [String]()
    var mylist_fire : FireMyList!
    var fetch: MylistFetch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.object(forKey: "userName") != nil{
            userName = UserDefaults.standard.object(forKey: "userName") as! String
        }
        
        userName = (Auth.auth().currentUser?.displayName)!
        userID = (Auth.auth().currentUser?.uid)!
        
        UserNameLabel.text = userName
        
        titleTextField.delegate = self
        detailTextView.delegate = self
        URLTextField.delegate = self
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addButton.isHidden = true
        addButton.isEnabled = false
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleName = titleTextField.text!
        detail = detailTextView.text!
        urlString = URLTextField.text!
        
       if titleName != "" && detail != ""{
            addButton.isHidden = false
            addButton.isEnabled = true
        }
        titleTextField.resignFirstResponder()
        detailTextView.resignFirstResponder()
        URLTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else{
            return false
        }
    }
    
    @IBAction func postAction(_ sender: Any) {
        
        titleName = titleTextField.text!
        detail = detailTextView.text!
        urlString = URLTextField.text!
        
        if titleName == "" || detail == ""{
            addButton.isHidden = true
            addButton.isEnabled = false
            
            return
        }
        
        //アラート機能
        showeAlart()
        
        //ボタンの設定
        addButton.isHidden = true
        addButton.isEnabled = false
        
        
    }
    
    func showeAlart(){
        let alertController = UIAlertController(title: "タイムラインに共有しますか？", message:"NOを押すと自分のリストにだけ追加できます", preferredStyle: .actionSheet)
       
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (alert) in
        }
        let OK = UIAlertAction(title: "OK", style: .default) { (alert) in
            //goodUserに一応入れておく
            self.goodUser.append(self.userID)
            self.timeLineAdd()
            self.mylistAdd()
            
            self.goodUser.removeAll()
            self.titleTextField.text = ""
            self.detailTextView.text = ""
            self.URLTextField.text = ""
           
        }
        
        let NO = UIAlertAction(title: "NO", style: .default) { (alert) in
            self.mylistAdd()

//            self.fetch.mylistAdd(userID: self.userID, titleName: self.titleName, detail: self.detail, urlString: self.urlString, count: self.count)
//
            self.titleTextField.text = ""
            self.detailTextView.text = ""
            self.URLTextField.text = ""
            
        }
        
        alertController.addAction(OK)
        alertController.addAction(NO)
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //タイムライン追加
    func timeLineAdd(){
        
        let timeLineDB = Database.database().reference().child("timeLines").childByAutoId()
        let timeLineInfo = ["userName":self.userName as Any , "titleName":self.titleName as Any,"detail": detail as Any,"URL":urlString as Any,"postDate":ServerValue.timestamp(),"count":count as Any,"userID":userID,"goodUser":goodUser] as [String:Any]
        timeLineDB.updateChildValues(timeLineInfo)
    }
    
    //myList追加
    func mylistAdd(){
        
        let myListDB = Database.database().reference().child("MyList").child(String(userID)).child("List").childByAutoId()
        let mylistInfo = ["titleName":self.titleName as Any, "detail": detail as Any,"URL":urlString as Any,"postDate":ServerValue.timestamp(),"usedcount":count as Any,"evaluation":count as Any] as [String:Any]
        myListDB.updateChildValues(mylistInfo)
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
