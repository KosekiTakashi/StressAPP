//
//  MyListFeatch.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/11/26.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import Foundation
import Firebase

struct MylistFeatch {
    let userID = (Auth.auth().currentUser?.uid)!
    let MyListref = Database.database().reference().child("MyList")
    func featch() {
        MyListref.child(userID).child("List").observe(.value) { (snapshot) in
        for child in snapshot.children{
            let childSnapshoto = child as! DataSnapshot
            
            let content = FireMyList(snapshot: childSnapshoto)
            
            let content1 = FireMyList(snapshot: childSnapshoto).titleNameString
            
        }
        }
    }
    
}
