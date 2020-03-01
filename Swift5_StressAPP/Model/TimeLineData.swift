//
//  Contents.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/10/09.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import Foundation
import Firebase

class TimeLineData {
    var userNameString:String = ""
    var titleNameString:String = ""
    var detail:String = ""
    var urlString:String = ""
    var count:Int = 0
    let userData = UserData()
    var userID :String = UserData().userID()
    var goodUser = [String]()
    var userProfileImage = ""
    
    let ref:DatabaseReference!
    
    init(userName:String,titleName:String,detail:String,urlString:String,count:Int,userID:String,goodUser:[String],userProfileImage:String) {
        self.userNameString = userName
        self.titleNameString = titleName
        self.detail = detail
        self.urlString = urlString
        self.count = count
        self.userID = userID
        self.goodUser = goodUser
        self.userProfileImage = userProfileImage
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
            userID = value["userID"] as! String
            goodUser = value["goodUser"] as! [String]
            userProfileImage = value["userProfileImage"] as! String
            
            
        }
    }
    
}

extension TimeLineData{
    
    func pluslike(){
        count += 1
        ref.child("count").setValue(count)
        let userData = UserData()
        let userID = userData.userID()
        let gooduserID = userID
        goodUser.append(gooduserID)
        ref.child("goodUser").setValue(goodUser)
    }
    
    func minuslike(){
        count -= 1
        ref.child("count").setValue(count)
        
    }
    
}





