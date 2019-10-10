//
//  SearchDetailViewController.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/10/05.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import UIKit
import Firebase

class SearchDetailViewController: UIViewController {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var deatailLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var addLabel: UILabel!
    
    var userName :String = ""
    var titleName :String = ""
    var detail :String = ""
    var urlString :String = ""
    
    var nameArray = [String]()
    var searchNameArray = [Contents]()
    var number = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = userName
        titleNameLabel.text = titleName
        deatailLabel.text = detail
        urlLabel.text = urlString
        
        addLabel.isHidden = true
        
        if UserDefaults.standard.object(forKey: "namearray") != nil{
            nameArray = UserDefaults.standard.object(forKey: "namearray") as! [String]
        }
        print(searchNameArray)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    
    @IBAction func addAction(_ sender: Any) {
        
        nameArray.append(titleName)
        UserDefaults.standard.set(nameArray, forKey: "namearray")
        
        let nextVC = storyboard?.instantiateViewController(identifier: "search") as! SearchViewController
        nextVC.searchNameArray.remove(at: number-1)
        
        addButton.isEnabled = false
        addLabel.isHidden = false
        
    }
    
    
    

        

}
