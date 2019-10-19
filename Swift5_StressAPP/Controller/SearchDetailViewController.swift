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
        
        if tapcount == 1{
            addButton.isEnabled = false
        }
    }
    
    
    
    @IBAction func addAction(_ sender: Any) {
        
        let mylist = Mylist()
        mylist.titleName = titleName
        mylist.detail = detail
        mylist.urlString = urlString
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(mylist)
        }
        
        
        addButton.isEnabled = false
        addLabel.isHidden = false
        
        
        //tap()
        //let nextVC = storyboard?.instantiateViewController(identifier: "Search") as! SearchViewController
        
        //nextVC.tapcount = 1
    }
    
    func tap(){
    
        if tapcount == 0 {
            content.pluslike()
            countLabel.text = "ダウンロード数：\(count)"
            tapcount = 1
        
        }else{
            content.minuslike()
            countLabel.text = "ダウンロード数：\(count)"
            tapcount = 0
            }
        
    }
    
    
    
    
    

        

}
