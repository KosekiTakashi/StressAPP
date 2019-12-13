//
//  DiaryManeger.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/11/30.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import Foundation
import Firebase

protocol DiaryDataFetchDelegate {
    func didFetch(List: Diary, titleNameList: String)
}


struct DiaryManeger {
    let MyListref = Database.database().reference().child("MyList")
    var delegate: DiaryDataFetchDelegate?
    
    func fetch(userID: String, selectday: String ){
        MyListref.child(userID).child("Diary").child(selectday).observe(.value) { (snapshot) in
            
            for child in snapshot.children{
                let childSnapshoto = child as! DataSnapshot
                let List = Diary(snapshot: childSnapshoto)
                let titleName = Diary(snapshot: childSnapshoto).titleName
                self.delegate?.didFetch(List: List, titleNameList: titleName)
                
            }
            
        }
    }
}