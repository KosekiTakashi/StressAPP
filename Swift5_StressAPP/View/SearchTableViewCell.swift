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
    
   
    var tapupcount = 0
    var tapdowncount = 0
    
    var userID = (Auth.auth().currentUser?.uid)!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    
    
    
    
    var content:Contents!{
        didSet{
            userNameLabel.text = content.userNameString
            titleNameLabel.text = content.titleNameString
            countLabel.text = String(content.count)
        }
    }
    
    
    
    @IBAction func addAciton(_ sender: Any) {
        tap()
    }
    
    
    func tap(){
        if tapupcount == 0 {
            content.pluslike()
            countLabel.text = String(content.count)
            mylistAdd()
            tapupcount = 1
            
            addButton.isEnabled = false
      
        }
        

    }
    
    func mylistAdd(){
        
        
        let myListDB = Database.database().reference().child("MyList").child(String(userID)).childByAutoId()
        
        let mylistInfo = ["titleName":content.titleNameString as Any,"detail": content.detail as Any,"URL":content.urlString as Any,"postDate":ServerValue.timestamp(),"count":content.count as Any] as [String:Any]
        
        myListDB.updateChildValues(mylistInfo)
        
        
    
    }
    
    
}

