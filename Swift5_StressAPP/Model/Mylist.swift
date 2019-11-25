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
    var usedCount = 0
    var evaluation = 0
//    var usedCount:Int = 0
    let ref:DatabaseReference!
    
    init(titleName:String,detail:String,urlString:String,useID:String,usedCount:Int,evaluation:Int) {
       
        self.titleNameString = titleName
        self.detail = detail
        self.urlString = urlString
        self.usedCount = usedCount
        self.evaluation = evaluation
        self.userID = useID
        
        ref = Database.database().reference().child("MyList").child(String(userID)).child("List").childByAutoId()
    }
    
    init(snapshot:DataSnapshot) {
        ref = snapshot.ref
        if let value = snapshot.value as? [String : Any]{
            titleNameString = value["titleName"] as! String
            detail = value["detail"] as! String
            urlString = value["URL"] as! String
            usedCount = value["usedcount"] as! Int
            evaluation = value["evaluation"] as! Int
            
        }
    }
}

extension FireMyList{
    
    func changeList(titleName:String,detail:String,urlString:String){
        ref.child("titleName").setValue(titleName)
        ref.child("detail").setValue(detail)
        ref.child("URL").setValue(urlString)
    }
    
    func usedEvaluation(eva:Int){
        usedCount += 1
        ref.child("usedcount").setValue(usedCount)
        
        evaluation += eva
        ref.child("evaluation").setValue(evaluation)
        
    }
    
}
