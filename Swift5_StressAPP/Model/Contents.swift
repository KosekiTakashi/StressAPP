//
//  Contents.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/10/09.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import Foundation
import RealmSwift

class Contents {
    var userNameString:String = ""
    var titleNameString:String = ""
    var detail:String = ""
    var urlString:String = ""
    
    
    init(userName:String,titleName:String,detail:String,urlString:String) {
        self.userNameString = userName
        self.titleNameString = titleName
        self.detail = detail
        self.urlString = urlString
    }
}



class Mylist: Object {

    @objc dynamic var titleName: String = ""
    @objc dynamic var detail: String = ""
    @objc dynamic var urlString: String = ""
    
}

