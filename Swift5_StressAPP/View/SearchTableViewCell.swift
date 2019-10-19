//
//  SearchTableViewCell.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/10/19.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import UIKit

class SerchTabViewCell: UITableViewCell {
    
   
    var tapupcount = 0
    var tapdowncount = 0
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    
    
    
    var content:Contents!{
        didSet{
            userNameLabel.text = content.userNameString
            titleNameLabel.text = content.titleNameString
            addButton.setTitle("❤️\(content.count)", for: [])
        }
    }
    
    
    
    @IBAction func addAciton(_ sender: Any) {
        tap()
    }
    
    
    func tap(){
        
        if tapupcount == 0 {
            content.pluslike()
            addButton.setTitle("❤️\(content.count)", for: [])
            tapupcount = 1
        }else{
            content.minuslike()
            addButton.setTitle("❤️\(content.count)", for: [])
            tapupcount = 0
            
        }
    }
    
    
}

