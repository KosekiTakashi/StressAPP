//
//  SearchTableViewCell.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/10/19.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class SerchTabViewCell: UITableViewCell {
    
   
    var tapcount = 0
    var tapdowncount = 0
    var timeuserID = ""
    var userID = (Auth.auth().currentUser?.uid)!
    var goodUser = [String]()
    var good = 0
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    
    
    
    
    var content:Contents!{
        didSet{
            userNameLabel.text = content.userNameString
            titleNameLabel.text = content.titleNameString
            countLabel.text = String(content.count)
            timeuserID = content.userID
            goodUser = content.goodUser
            
            print("---------------")
            print("username_\(content.userNameString)")
            print("title_\(content.titleNameString)")
            print("userID_\(userID)")
            print("timeuserID_\(timeuserID)")
            print("goodUsers_\(goodUser)")
        
            
            //比較してみる
            
            for i in goodUser{
                if i == userID{
                    good = 1
                }
            }
            
            print("good_\(good)")
            
            if good == 1 {
                print("NOT")
                addButton.isEnabled = false
            }else{
                print("YES")
                addButton.isEnabled = true
                //|| timeuserID == userID
            }
            
        }
    }
 
    
    @IBAction func addAciton(_ sender: Any) {
        content.pluslike()
        countLabel.text = String(content.count)
        mylistAdd()
    }
    
    func mylistAdd(){
        let myListDB = Database.database().reference().child("MyList").child(String(userID)).childByAutoId()
        
        let mylistInfo = ["titleName":content.titleNameString as Any,"detail": content.detail as Any,"URL":content.urlString as Any,"postDate":ServerValue.timestamp(),"count":content.count as Any] as [String:Any]
        
        myListDB.updateChildValues(mylistInfo)
        
        
    
    }
    
    
}

