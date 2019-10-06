//
//  SearchDetailViewController.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/10/05.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import UIKit

class SearchDetailViewController: UIViewController {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    @IBOutlet weak var addLabel: UILabel!
    
    var name :String = ""
    var nameArray = [String]()
    var searchNameArray = [String]()
    var tapcount = 0
    var number = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = name
        
        addLabel.isHidden = true
        
        if UserDefaults.standard.object(forKey: "namearray") != nil{
            nameArray = UserDefaults.standard.object(forKey: "namearray") as! [String]
        }
        
        if UserDefaults.standard.object(forKey: "serachNameArray") != nil{
                searchNameArray = UserDefaults.standard.object(forKey: "serachNameArray") as! [String]
                
            }
        
            print(searchNameArray)
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    
    
    @IBAction func addAction(_ sender: Any) {
        
        nameArray.append(name)
        UserDefaults.standard.set(nameArray, forKey: "namearray")
        
        addButton.isEnabled = false
        addLabel.isHidden = false
        
        searchNameArray.remove(at: number)
        print(searchNameArray)
        UserDefaults.standard.set(searchNameArray, forKey: "serachNameArray")
    }
    
        

}
