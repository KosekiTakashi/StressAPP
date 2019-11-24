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
    var test = ""
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var titleNameLabel: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    var content:Contents!{
        didSet{
            userNameLabel.text = content.userNameString
            titleNameLabel.text = content.titleNameString
            countLabel.text = ("ダウンロード数：\(content.count)")
            userNameLabel.text = test
            
            
            //比較してみる
            
//            for i in goodUser{
//                if i == userID{
//                    good = 1
//                }
//            }
//            if good == 1 {
//                print("NOT")
//            }else{
//                print("YES")
//                //|| timeuserID == userID
//            }
//
       }
    }
    
 
    
    func mylistAdd(){
        let myListDB = Database.database().reference().child("MyList").child(String(userID)).childByAutoId()
        
        let mylistInfo = ["titleName":content.titleNameString as Any,"detail": content.detail as Any,"URL":content.urlString as Any,"postDate":ServerValue.timestamp(),"count":content.count as Any] as [String:Any]
        
        myListDB.updateChildValues(mylistInfo)
        
        
    
    }
    
    
}

