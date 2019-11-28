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
    func didFeatch(_ ListManeger: MylistFeatch, List: FireMyList)
}

struct MylistFeatch {
    
    var MyList = [FireMyList]()
    var mylist : FireMyList!
    var delegate:MyListFeatchDelegate?
    let userID = (Auth.auth().currentUser?.uid)!
    let MyListref = Database.database().reference().child("MyList")
    
    func featch() {
        MyListref.child(userID).child("List").observe(.value) { (snapshot) in
            for child in snapshot.children{
                let childSnapshoto = child as! DataSnapshot
            
                let content = FireMyList(snapshot: childSnapshoto)
                self.delegate?.didFeatch(self, List: content)
            
                let content1 = FireMyList(snapshot: childSnapshoto).titleNameString
            
        }
        }
    }
    
}
