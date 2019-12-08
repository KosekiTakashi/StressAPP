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
}
