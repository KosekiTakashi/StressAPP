//
//  TimeLineManeger.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/11/30.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import Foundation
import Firebase


class TimeLineManeger {
    let timeLinesref = Database.database().reference().child("timeLines")
    
    
    func fetch(callback: @escaping ([TimeLineData]) -> Void) {
        timeLinesref.observe(.value) { (snapshot) in
            let data = snapshot.children.map { child -> TimeLineData in
                let childSnapshoto = child as! DataSnapshot
                return TimeLineData(snapshot: childSnapshoto)
            }
            callback(data)
        }
    }
    
    func timeLineAdd(userName: String, userID:String, titleName: String, detail: String, urlString: String, count: Int, goodUser: [String],userImage: UIImage){
        
        let timeLineDB = timeLinesref.childByAutoId()
        let userprofileImageData = (userImage.jpegData(compressionQuality: 0.01)!)
        let storageRef = Storage.storage().reference()
        let key = timeLineDB.child("Users").childByAutoId().key
        let riversRef = storageRef.child("userImage").child("userlogo").child("\(String(describing: key!)).jpg")

        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = riversRef.putData(userprofileImageData, metadata: nil) { (metadata, error) in
          guard let metadata = metadata else {
            return
          }
            
          let size = metadata.size
          print(size)
            
          riversRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
                print(error as Any)
              return
            }
            
            let timeLineInfo = ["userName": userName as Any ,
                                "titleName":titleName as Any,
                                "detail": detail as Any,
                                "URL":urlString as Any,
                                "postDate":ServerValue.timestamp(),
                                "count":count as Any,
                                "userID":userID,
                                "goodUser":goodUser,
                                "userProfileImage":downloadURL.absoluteString as Any]
                as [String:Any]

            timeLineDB.updateChildValues(timeLineInfo)
            }
        }
        uploadTask.resume()
        
    }
    
    
    
    
        
}
