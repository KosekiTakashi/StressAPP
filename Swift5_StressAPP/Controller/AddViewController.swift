//
//  AddViewController.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/10/07.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import UIKit
import Firebase
import Lottie
import SDWebImage

class AddViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var URLTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    
   
    var userName = ""
    var userID = ""
    var titleName = String()
    var detail = String()
    var urlString = String()
    var mylistArray = [String]()
    var count = Int()
    var goodUser = [String]()
    var mylist_fire : MyListData!
    
    var myListmaneger = MyListManeger()
    var timeLineManeger = TimeLineManeger()
    
    let userData = UserData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoImageView.layer.cornerRadius = logoImageView.frame.height/2
        
        titleTextField.delegate = self
        detailTextView.delegate = self
        URLTextField.delegate = self
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let userName = Auth.auth().currentUser?.displayName{
            UserNameLabel.text = userName
        }
        
        if let userID = (Auth.auth().currentUser?.uid){
            self.userID = userID
            let imageURL = userData.userImageURL(userID: userID)
            print("imageURL")
            print(imageURL)
            if imageURL == "NoName"{
                logoImageView.image = UIImage(named: "noimage")!
            }else{
                logoImageView.sd_setImage(with: URL(string: imageURL), completed: nil)
            }
        }
    }
    
    
    
    @IBAction func tappedLabel(_ sender: UITapGestureRecognizer) {
        
        performSegue(withIdentifier: "UserData", sender: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
    
    @IBAction func postAction(_ sender: Any) {
        
        titleName = titleTextField.text!
        detail = detailTextView.text!
        urlString = URLTextField.text!
        
        if titleName == "" || detail == ""{
            return
        }
        
        //アラート機能
        showeAlart()
        
    }
    
    //MARK: - Alart
    
    func showeAlart(){
        let alertController = UIAlertController(title: "タイムラインに共有しますか？", message:"NOを押すと自分のリストにだけ追加できます", preferredStyle: .actionSheet)
       
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (alert) in
        }
        let OK = UIAlertAction(title: "OK", style: .default) { (alert) in
            
            self.goodUser.append(self.userID)
            if let userName = Auth.auth().currentUser?.displayName{
    
                self.timeLineManeger.timeLineAdd(userName: userName,
                                                 userID: self.userID,
                                                 titleName: self.titleName,
                                                 detail: self.detail,
                                                 urlString: self.urlString,
                                                 count: self.count,
                                                 goodUser: self.goodUser,
                                                 userImage: self.userData.imageData())
                
                
                self.myListmaneger.mylistAdd(userID: self.userID,
                                             titleName: self.titleName,
                                             detail: self.detail,
                                             urlString: self.urlString,
                                             count: self.count)
            
            }
            
            DispatchQueue.main.async{
                self.goodUser.removeAll()
                self.titleTextField.text = ""
                self.detailTextView.text = ""
                self.URLTextField.text = ""
            }
        }
        
        let NO = UIAlertAction(title: "NO", style: .default) { (alert) in
            
            self.myListmaneger.mylistAdd(userID: self.userID,
                                         titleName: self.titleName,
                                         detail: self.detail,
                                         urlString: self.urlString,
                                         count: self.count)
            
            DispatchQueue.main.async {
                self.titleTextField.text = ""
                self.detailTextView.text = ""
                self.URLTextField.text = ""
            }
        }
        
        alertController.addAction(OK)
        alertController.addAction(NO)
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true, completion: nil)
    }

}
