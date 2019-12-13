//
//  userData.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/12/03.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import Firebase

struct UserData {
    static let userID = (Auth.auth().currentUser?.uid)!
    static let userName = (Auth.auth().currentUser?.displayName)!
    static let userEmail = (Auth.auth().currentUser?.email)!
    static let userCreateDay = (Auth.auth().currentUser?.metadata.creationDate)!
    
    func ImageData() -> UIImage{
        if UserDefaults.standard.object(forKey: "userImage\(UserData.userID)") != nil{
            
            let userImageData = UserDefaults.standard.object(forKey: "userImage\(UserData.userID)") as! Data
            let userImage = UIImage(data: userImageData)!
            return userImage
        }
        return UIImage(named: "noimage")!
    }
    
    func userNameData() -> String{
        if UserDefaults.standard.object(forKey: "userName\(UserData.userID)") != nil{
            let username = UserDefaults.standard.object(forKey: "userName\(UserData.userID)") as! String
            return username
        }
        return "NoName"
    }
    
}
