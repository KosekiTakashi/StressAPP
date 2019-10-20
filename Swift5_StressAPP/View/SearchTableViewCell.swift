//
//  SearchTableViewCell.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/10/19.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import UIKit
import RealmSwift

class SerchTabViewCell: UITableViewCell {
    
   
    var tapupcount = 0
    var tapdowncount = 0
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    
    
    
    
    var content:Contents!{
        didSet{
            userNameLabel.text = content.userNameString
            titleNameLabel.text = content.titleNameString
            countLabel.text = String(content.count)
        }
    }
    
    
    
    @IBAction func addAciton(_ sender: Any) {
        tap()
    }
    
    
    func tap(){
        if tapupcount == 0 {
            content.pluslike()
            countLabel.text = String(content.count)
            mylistAdd()
            tapupcount = 1
            UserDefaults.standard.set(tapupcount, forKey: "tapcount")
            addButton.isEnabled = false
        }else{
            //content.minuslike()
            //addButton.setTitle("dawnload\(content.count)", for: [])
            //tapupcount = 0
            addButton.isEnabled = false
        }
        

    }
    
    func mylistAdd(){
        let mylist = Mylist()
        mylist.titleName = content.titleNameString
        mylist.detail = content.detail
        mylist.urlString = content.urlString
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(mylist)
        }
    }
    
    
}

