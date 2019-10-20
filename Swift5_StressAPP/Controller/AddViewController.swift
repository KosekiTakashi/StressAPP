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
    
    var mylist_fire : MyList!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.object(forKey: "userName") != nil{
            userName = UserDefaults.standard.object(forKey: "userName") as! String
        }
        
        userName = (Auth.auth().currentUser?.displayName)!
        userID = (Auth.auth().currentUser?.uid)!
        
        print(userID)
        
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
    
    
    
    @IBAction func postAction(_ sender: Any) {
        
        titleName = titleTextField.text!
        detail = detailTextView.text!
        urlString = URLTextField.text!
        
        if titleName == "" || detail == ""{
            addButton.isHidden = true
            addButton.isEnabled = false
            
            return
        }
        
        showeAlart()
        
        
        addButton.isHidden = true
        addButton.isEnabled = false
        
        
    }
    
    func showeAlart(){
        let alertController = UIAlertController(title: "タイムラインに共有しますか？", message:"NOを押すと自分のリストにだけ追加できます", preferredStyle: .actionSheet)
       
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (alert) in
        }
        
        
        
        let OK = UIAlertAction(title: "OK", style: .default) { (alert) in
            self.timeLineAndmyListAdd()
            self.titleTextField.text = ""
            self.detailTextView.text = ""
            self.URLTextField.text = ""
        }
        
        let NO = UIAlertAction(title: "NO", style: .default) { (alert) in
            self.mylistAdd()
            self.titleTextField.text = ""
            self.detailTextView.text = ""
            self.URLTextField.text = ""
        }
        
        alertController.addAction(OK)
        alertController.addAction(NO)
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func timeLineAndmyListAdd(){
        //タイムライン
        let timeLineDB = Database.database().reference().child("timeLines").childByAutoId()
        let timeLineInfo = ["userName":self.userName as Any , "titleName":self.titleName as Any,"detail": detail as Any,"URL":urlString as Any,"postDate":ServerValue.timestamp(),"count":count as Any] as [String:Any]
        
        print("timeLines")
        timeLineDB.updateChildValues(timeLineInfo)
        
        //自分のリスト
        let mylist = Mylist()
        mylist.titleName = titleName
        mylist.detail = detail
        mylist.urlString = urlString
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(mylist)
        }
        //addmylist(uid: userID, mylist: mylist_fire )
    }
    
    
    func mylistAdd(){
        let mylist = Mylist()
        mylist.titleName = titleName
        mylist.detail = detail
        mylist.urlString = urlString
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(mylist)
        }
    }
    
    
    func firebaseMylistAdd(userID:String,mylist:MyList){
        let ref = Database.database().reference()
        let key = ref.child("mylist").childByAutoId().key
        
        let update = ["/userMyList/\(key)/":["title":mylist.titleNameString,"detail":mylist.detail,"url":mylist.urlString]]
        ref.updateChildValues(update)
    }
    
    func uid() -> String{
        return Auth.auth().currentUser!.uid
    }
    
    
    func addmylist(uid:String,mylist:MyList){
        firebaseMylistAdd(userID: userID, mylist: MyList(titleName: titleName, detail: detail, urlString: urlString, key: userID ))
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
