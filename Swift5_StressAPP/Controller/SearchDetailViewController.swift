//
//  SearchDetailViewController.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/10/05.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class SearchDetailViewController: UIViewController {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var deatailLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var addLabel: UILabel!
    
    var userName :String = ""
    var titleName :String = ""
    var detail :String = ""
    var urlString :String = ""
    var count = Int()
    
    var searchNameArray = [TimeLineData]()
    
    var content:TimeLineData!
    var userID = UserData.userID
    var timeuserID = ""
    var good = 0
    var goodUsers = [String]()
    var myListManeger = MyListManeger()
    
    var contents:TimeLineData!{
           didSet{
               userName = contents.userNameString
               count = contents.count
               titleName = contents.titleNameString
               detail = contents.detail
               urlString = contents.urlString
               timeuserID = contents.userID
               goodUsers = contents.goodUser
            
            
           }
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = userName
        titleNameLabel.text = titleName
        deatailLabel.text = detail
        urlLabel.text = urlString
        countLabel.text = "ダウンロード数：\(count)"

        addLabel.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
       
        for i in goodUsers{
            if i == userID{
                good = 1
            }
        }
        if good == 1 || timeuserID == userID{
            
            addButton.isEnabled = false
            
            addLabel.text = "追加済み"
            addButton.title = "追加済み"
        }else{
            
            addButton.isEnabled = true
        }
    }
    
    
    
    @IBAction func addAction(_ sender: Any) {
        
        myListManeger.mylistAdd(userID: userID, titleName: titleName, detail: detail, urlString: urlString, count: count)
        
        addButton.isEnabled = false
        addLabel.text = "追加しました！！！"
        addButton.title = "追加済み"
        
        contents.pluslike()
        countLabel.text = "ダウンロード数：\(count)"
    
    }
}
