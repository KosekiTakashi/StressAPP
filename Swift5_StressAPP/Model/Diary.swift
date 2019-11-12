//
//  Calendar.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/11/12.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import Foundation
import Firebase


class Diary{
    var titleName = String()
    var stressCount = Int()
    var selectedList = String()
    var result = String()
    var evaluation = Int()
    var timeString = String()
    var userID:String = ""
    let ref:DatabaseReference!
    
    
    init(timeString:String,userID:String, titleName:String, stressCount:Int, selectedList:String,result:String,evaluation:Int) {
       
        self.titleName = titleName
        self.stressCount = stressCount
        self.selectedList = selectedList
        self.result = result
        self.evaluation = evaluation
        self.timeString = timeString
        self.userID = userID
        
        ref = Database.database().reference().child("MyList").child(String(userID)).child("Diary").childByAutoId()
    }
    
    init(snapshot:DataSnapshot) {
        ref = snapshot.ref
        if let value = snapshot.value as? [String : Any]{
            titleName = value["titleName"] as! String
            stressCount = value["stressCount"] as! Int
            selectedList = value["selectedList"] as! String
            result = value["result"] as! String
            evaluation = value["evaluation"] as! Int
            timeString = value["timeString"] as! String
        }
    }
    
    
    func toDictionary(titleName:String, stressCount:Int, selectedList:String,result:String,evaluation:Int) ->[String:Any]{
        
        return["titleName":titleName,"stressCount":stressCount,"selectedList":selectedList,"result":result,"evaluation":evaluation]
    }
    
    
}

