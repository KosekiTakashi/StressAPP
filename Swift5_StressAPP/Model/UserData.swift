//
//  userData.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/12/03.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import Firebase

struct UserData {
    
    func userImageURL(userID: String) -> String{
        if UserDefaults.standard.object(forKey: "userImageURL\(userID)") != nil{
            
            let userImageURL = UserDefaults.standard.object(forKey: "userImageURL\(userID)") as! String
            print("test_\(userImageURL)")
            return userImageURL
        }
        return "NoName"
    }
    
    func userName() -> String{
        if let userName = (Auth.auth().currentUser?.displayName){
            return userName
        }else{
            return "NoName"
        }
        
    }
    
    func userID() -> String{
        if let userID = (Auth.auth().currentUser?.uid){
            return userID
        }else{
            return "NoName"
        }
        
    }
    
    func userEmail() -> String{
        if let userEmail = (Auth.auth().currentUser?.email){
            return userEmail
        }else{
            return "NoName"
        }
        
    }
    
    func userCreateDate() -> Date{
        if let userCreateDay = (Auth.auth().currentUser?.metadata.creationDate){
            return userCreateDay
        }else{
            return Date()
        }
        
    }
    
    
    func userNameData() -> String{

        let userData = UserData()
        let userID = userData.userID()

        if UserDefaults.standard.object(forKey: "userName\(userID)") != nil{
            let username = UserDefaults.standard.object(forKey: "userName\(userID)") as! String
            return username
        }
        return "NoName"
    }
    
    func ImageData() -> UIImage{
        let userData = UserData()
        let userID = userData.userID()
        if UserDefaults.standard.object(forKey: "userImage\(userID)") != nil{
            
            let userImageData = UserDefaults.standard.object(forKey: "userImage\(userID)") as! Data
            let userImage = UIImage(data: userImageData)!
            return userImage
        }
        return UIImage(named: "noimage")!
    }
    
    
    
}
