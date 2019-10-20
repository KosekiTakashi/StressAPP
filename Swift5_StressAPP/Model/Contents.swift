//
//  Contents.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/10/09.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import Foundation
import RealmSwift
import Firebase

class Contents {
    var userNameString:String = ""
    var titleNameString:String = ""
    var detail:String = ""
    var urlString:String = ""
    var count:Int = 0
    let ref:DatabaseReference!
    
    init(userName:String,titleName:String,detail:String,urlString:String,count:Int) {
        self.userNameString = userName
        self.titleNameString = titleName
        self.detail = detail
        self.urlString = urlString
        self.count = count
        
        ref = Database.database().reference().child("timeLines").childByAutoId()
        
    }
    
    init(snapshot:DataSnapshot) {
        ref = snapshot.ref
        if let value = snapshot.value as? [String : Any]{
            userNameString = value["userName"] as! String
            titleNameString = value["titleName"] as! String
            detail = value["detail"] as! String
            urlString = value["URL"] as! String
            count = value["count"] as! Int
            
        }
    }
    
    func save(){
        ref.setValue(toDictionary())
    }
    
    func toDictionary() ->[String:Any]{
        
        return["userName":userNameString,"titleName":titleNameString,"detail":detail,"URL":urlString,"count":count]
    }
}

extension Contents{
    
    func pluslike(){
        count += 1
        ref.child("count").setValue(count)
    }
    
    func minuslike(){
        count -= 1
        ref.child("count").setValue(count)
        
    }
    
}





