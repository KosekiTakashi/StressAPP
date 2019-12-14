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
    
    func timeLineAdd(userName: String, userID:String, titleName: String, detail: String, urlString: String, count: Int, goodUser: [String],userImage: UIImage){
        
        let timeLineDB = Database.database().reference().child("timeLines").childByAutoId()
        // Data in memory
        var data = Data()
        let userprofileImageData = (userImage.jpegData(compressionQuality: 0.01)!)
        data = userprofileImageData
        let storageRef = Storage.storage().reference()
        let riversRef = storageRef.child("userImage").child("userlogo")

        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = riversRef.putData(data, metadata: nil) { (metadata, error) in
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
            print(downloadURL)
            print("---------------------------")
            let timeLineInfo = ["userName": userName as Any , "titleName":titleName as Any,"detail": detail as Any,"URL":urlString as Any,"postDate":ServerValue.timestamp(),"count":count as Any,"userID":userID,"goodUser":goodUser,"userProfileImage":url?.absoluteString as Any] as [String:Any]

            timeLineDB.updateChildValues(timeLineInfo)
            }
        }
    }
        
//        let timeLineDB = Database.database().reference().child("timeLines").childByAutoId()
//        //画像 storageについて
//        let storage = Storage.storage().reference(forURL: "gs://stressapp-7d738.appspot.com")
//        let key = timeLineDB.child("Users").childByAutoId().key
//        let imageref = storage.child("Users").child("\(String(describing: key!)).jpg")
//        let userprofileImageData = (userImage.jpegData(compressionQuality: 0.01)!)
//
//        let uploadTask = imageref.putData(userprofileImageData, metadata: nil){
//        (metaData,error) in
//            if error != nil{
//                print(error as Any)
//                return
//            }else{
//                print("成功")
//            }
//
//        }
//
//        imageref.downloadURL { (url, error) in
//            if url != nil{
//                print("---------------------------")
//                let timeLineInfo = ["userName": userName as Any , "titleName":titleName as Any,"detail": detail as Any,"URL":urlString as Any,"postDate":ServerValue.timestamp(),"count":count as Any,"userID":userID,"goodUser":goodUser,"userProfileImage":url?.absoluteString as Any] as [String:Any]
//
//                timeLineDB.updateChildValues(timeLineInfo)
//            }else{
//                print(error as Any)
//                print("----------------test-------------")
//                let timeLineInfo = ["userName": userName as Any , "titleName":titleName as Any,"detail": detail as Any,"URL":urlString as Any,"postDate":ServerValue.timestamp(),"count":count as Any,"userID":userID,"goodUser":goodUser] as [String:Any]
//
//                timeLineDB.updateChildValues(timeLineInfo)
//            }
//        }
//
//    }
        
}
