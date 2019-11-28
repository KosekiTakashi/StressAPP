//
//  SearchDetailViewController.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/10/05.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class SearchDetailViewController: UIViewController {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var deatailLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var addLabel: UILabel!
    
    var userName :String = ""
    var titleName :String = ""
    var detail :String = ""
    var urlString :String = ""
    var count = Int()
    
    var searchNameArray = [Contents]()
    
    var content:Contents!
    var userID = String()
    var timeuserID = ""
    var good = 0
    var goodUsers = [String]()
    
    var contents:Contents!{
           didSet{
               userName = contents.userNameString
               count = contents.count
               titleName = contents.titleNameString
               detail = contents.detail
               urlString = contents.urlString
               timeuserID = contents.userID
               goodUsers = contents.goodUser
            
            
           }
       }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = userName
        titleNameLabel.text = titleName
        deatailLabel.text = detail
        urlLabel.text = urlString
        countLabel.text = "ダウンロード数：\(count)"

        addLabel.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userID = (Auth.auth().currentUser?.uid)!
       
        for i in goodUsers{
            if i == userID{
                good = 1
            }
        }
        if good == 1 || timeuserID == userID{
            
            addButton.isEnabled = false
            //addLabel.isHidden = false
            addLabel.text = "追加済み"
            addButton.title = "追加済み"
        }else{
            
            addButton.isEnabled = true
        }
    }
    
    
    
    @IBAction func addAction(_ sender: Any) {
        let myListDB = Database.database().reference().child("MyList").child(String(userID)).childByAutoId()
        
        let mylistInfo = ["titleName":titleName as Any,"detail": detail as Any,"URL":urlString as Any,"postDate":ServerValue.timestamp(),"count":count as Any] as [String:Any]
        
        myListDB.updateChildValues(mylistInfo)
        
        addButton.isEnabled = false
        //addLabel.isHidden = false
        addLabel.text = "追加しました！！！"
        addButton.title = "追加済み"
        tap()
        
    }
    
    func tap(){

        contents.pluslike()
        countLabel.text = "ダウンロード数：\(count)"
            
        
    }
    
    
    
    
    

        

}
