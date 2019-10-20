//
//  Mylist.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/10/20.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import Foundation
import Firebase


class FireMyList{
    var titleNameString:String = ""
    var detail:String = ""
    var urlString:String = ""
    var userID:String = ""
    let ref:DatabaseReference!
    
    init(titleName:String,detail:String,urlString:String,useID:String) {
       
        self.titleNameString = titleName
        self.detail = detail
        self.urlString = urlString
        self.userID = useID
        
        ref = Database.database().reference().child("MyList").child(String(userID)).childByAutoId()
    }
    
    init(snapshot:DataSnapshot) {
        ref = snapshot.ref
        if let value = snapshot.value as? [String : Any]{
            titleNameString = value["titleName"] as! String
            detail = value["detail"] as! String
            urlString = value["URL"] as! String
        }
    }
    
    func save(){
        ref.setValue(toDictionary())
    }
    
    func toDictionary() ->[String:Any]{
        
        return["titleName":titleNameString,"detail":detail,"URL":urlString]
    }
    
    
}
