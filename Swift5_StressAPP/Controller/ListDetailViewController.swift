//
//  ListDetailViewController.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/10/04.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import UIKit
import Firebase

class ListDetailViewController: UIViewController {
    
    
    @IBOutlet weak var titlenameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var urlStringLabel: UILabel!
    @IBOutlet weak var evaluationLabel: UILabel!
    
    
    var titleName : String = ""
    var detail : String = ""
    var urlString : String = ""
    var usedCount = 0
    var evaluation = 0
    
    var MyList = [FireMyList]()
    let MyListref = Database.database().reference().child("MyList")
    var indexNumber = 0
    
    var myLists:FireMyList!{
        didSet{
            titleName = myLists.titleNameString
            detail = myLists.detail
            urlString = myLists.urlString
            usedCount = myLists.usedCount
            evaluation = myLists.evaluation
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titlenameLabel.text = titleName
        detailLabel.text = detail
        urlStringLabel.text = urlString
        if usedCount != 0{
            let ave:Int = evaluation / usedCount
            evaluationLabel.text = "\(ave) (使用回数：\(usedCount))"
        }else{
            evaluationLabel.text = "未使用です"
        }
        self.titlenameLabel.text = titleName
        self.detailLabel.text = detail
        self.urlStringLabel.text = urlString
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let userID = (Auth.auth().currentUser?.uid)!
        MyListref.child(userID).child("List").observe(.value) { (snapshot) in
           self.MyList.removeAll()
           for child in snapshot.children{
               let childSnapshoto = child as! DataSnapshot
               let content = FireMyList(snapshot: childSnapshoto)
               self.MyList.insert(content, at: 0)
           }
//        self.titlenameLabel.text = self.MyList[self.indexNumber].titleNameString
//        self.detailLabel.text = self.MyList[self.indexNumber].detail
//        self.urlStringLabel.text = self.MyList[self.indexNumber].urlString
//        
        
            
            
        }
        
    }
    
    
    @IBAction func change(_ sender: Any) {
        
        let nextVC = storyboard?.instantiateViewController(identifier: "ListChange") as! ListChangeViewController
        
        let mylist = MyList[indexNumber]
        nextVC.myLists = mylist
        
    
        navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
}
