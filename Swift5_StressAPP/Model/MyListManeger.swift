//
//  MyListFeatch.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/11/26.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import Foundation
import Firebase

protocol MyListFeatchDelegate {
    func didFetch(List: FireMyList,titleNameList: String)
}

struct MyListManeger {
    
    var MyList = [FireMyList]()
    var mylist : FireMyList!
    var delegate:MyListFeatchDelegate?
    let userID = (Auth.auth().currentUser?.uid)!
    let MyListref = Database.database().reference().child("MyList")
    
    func fetch() {
        MyListref.child(userID).child("List").observe(.value) { (snapshot) in
            for child in snapshot.children{
                let childSnapshoto = child as! DataSnapshot
            
                let content = FireMyList(snapshot: childSnapshoto)
                let nameContent = FireMyList(snapshot: childSnapshoto).titleNameString
                self.delegate?.didFetch(List: content,titleNameList: nameContent)
            }
        }
    }
    
    func mylistAdd(userID:String, titleName: String, detail: String, urlString: String, count: Int){
        
        let myListDB = Database.database().reference().child("MyList").child(userID).child("List").childByAutoId()
        let mylistInfo = ["titleName":titleName as Any, "detail": detail as Any,"URL":urlString as Any,"postDate":ServerValue.timestamp(),"usedcount":count as Any,"evaluation":count as Any] as [String:Any]
        myListDB.updateChildValues(mylistInfo)
    }
    
}
