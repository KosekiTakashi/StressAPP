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

    var searchNameArray = [Contents]()
    var number = 0
    var count = Int()
    var tapcount = Int()
    var content:Contents!
    var userID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = userName
        titleNameLabel.text = titleName
        deatailLabel.text = detail
        urlLabel.text = urlString
        countLabel.text = "ダウンロード数：\(count)"
        
        addLabel.isHidden = true
        print(tapcount)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userID = (Auth.auth().currentUser?.uid)!
        if tapcount == 1{
            addButton.isEnabled = false
        }
    }
    
    
    
    @IBAction func addAction(_ sender: Any) {
        let myListDB = Database.database().reference().child("MyList").child(String(userID)).childByAutoId()
        
        let mylistInfo = ["titleName":titleName as Any,"detail": detail as Any,"URL":urlString as Any,"postDate":ServerValue.timestamp(),"count":count as Any] as [String:Any]
        
        myListDB.updateChildValues(mylistInfo)
        
        
        
        addButton.isEnabled = false
        addLabel.isHidden = false
        
        
        
    }
    
    func tap(){
    
        if tapcount == 0 {
            content.pluslike()
            countLabel.text = "ダウンロード数：\(count)"
            tapcount = 1
        
        }
        
    }
    
    
    
    
    

        

}
