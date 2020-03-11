//
//  MyListFeatch.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/11/26.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import Foundation
import Firebase



struct MyListManeger {
    
    let userID = UserData.userID
    let MyListref = Database.database().reference().child("MyList")
    
    func fetch(userID: String, callback: @escaping ([MyListData]) -> Void) {
        MyListref.child(userID).child("List").observe(.value){ (snapshot) in
            let data = snapshot.children.map { child -> MyListData in
                let childSnapshoto = child as! DataSnapshot
                return MyListData(snapshot: childSnapshoto)
            }
            callback(data)
        }
    }
    func mylistAdd(userID:String, titleName: String, detail: String, urlString: String, count: Int){
        
        let myListDB = Database.database().reference().child("MyList").child(userID).child("List").childByAutoId()
        let mylistInfo = ["titleName":titleName as Any,
                          "detail": detail as Any,
                          "URL":urlString as Any,
                          "postDate":ServerValue.timestamp(),
                          "usedcount":count as Any,
                          "evaluation":count as Any] as [String:Any]
        
        myListDB.updateChildValues(mylistInfo)
        
    
    }
    
    
}
