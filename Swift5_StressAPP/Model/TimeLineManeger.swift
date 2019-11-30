//
//  TimeLineManeger.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/11/30.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import Foundation
import Firebase

protocol TimeLineDataFetchDelegate {
    func didFetch(List: TimeLineData,titleNameList: String)
}

struct TimeLineManeger {
    let timeLinesref = Database.database().reference().child("timeLines")
    var delegate: TimeLineDataFetchDelegate?
    
    func fetch() {
        
        timeLinesref.observe(.value) { (snapshot) in
                
            for child in snapshot.children{
                let childSnapshoto = child as! DataSnapshot
                
                let contentList = TimeLineData(snapshot: childSnapshoto)
                let contentTitleName = TimeLineData(snapshot: childSnapshoto).titleNameString
                self.delegate?.didFetch(List: contentList, titleNameList: contentTitleName)
            }
        }
    }
    
    func timeLineAdd(userName: String, userID:String, titleName: String, detail: String, urlString: String, count: Int, goodUser: [String]){
        
        let timeLineDB = Database.database().reference().child("timeLines").childByAutoId()
        let timeLineInfo = ["userName": userName as Any , "titleName":titleName as Any,"detail": detail as Any,"URL":urlString as Any,"postDate":ServerValue.timestamp(),"count":count as Any,"userID":userID,"goodUser":goodUser] as [String:Any]
        
        timeLineDB.updateChildValues(timeLineInfo)
    }
}
